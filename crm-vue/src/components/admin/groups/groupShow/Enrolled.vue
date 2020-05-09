<template>
  <div>
    <input type="checkbox" v-model="selectAll"> Выбрать всех
    <download-excel
        class   = "btn btn-default"
        :data   = "json_data">
        <font-awesome-icon :icon="['far', 'file-excel']" class="fa-md-sm iconExcel"/>
      </download-excel>
        <download-excel
          class   = "btn btn-default"
          :data   = "json_data"
          :fields = "json_fields"
          type    = "csv"
          name    = "filename.xls">

          <font-awesome-icon :icon="['fas', 'file-csv']" class="fa-md-sm iconExcel"/>

      </download-excel>
        <table class="table first-td-padding table-striped">
          <thead>
            <tr>
              <th>ID</th>
              <th>Имя</th>
              <th>Телефон</th>
              <th>Почта</th>
              <th>Оплаты</th>
              <th>Действия</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="enrollments_enrolled.length" v-for="enrollment in enrollments_enrolled" :key='enrollment.id' :request="enrollment" v-bind:class="{enrolled:enrollment.status == 'enrolled'}">
              <td>
                <input class="mr-2" v-show="checked===true" type="checkbox" v-model="selected" :value="enrollment.id" number>{{ enrollment.id }}
              </td>
              <td>
                <router-link :to="`/admin/groups/${group.id}/enrollments/${enrollment.id}`">
                  {{ users[enrollment.user_id].name }}
                </router-link>
              </td>
              <td>
                {{ users[enrollment.user_id].phone }}
              </td>
              <td>
                {{ users[enrollment.user_id].email }}
              </td>

              <td>
                <div v-if="paid_days[enrollment.id] > 0" class="btn btn btn-sm btn-success btn-secondary">
                  {{ paid_days[enrollment.id] }}
                </div>
                <div v-if="paid_days[enrollment.id] === 0" class="btn btn-sm btn-warning">
                  {{ paid_days[enrollment.id] }}
                </div>
                <div v-if="paid_days[enrollment.id] < 0" class="btn btn btn-sm btn-danger">
                  {{ paid_days[enrollment.id] }}
                </div>
                | {{paid_sum[enrollment.id]}} | {{paid_amount[enrollment.id]}}
              </td>
              <td v-if="showEnrollmentLink()">
                <div v-show="enrollment === editedEnrollment" @click="updateEnrollment(enrollment)">
                  <i class="btn btn-primary mb-3">Edit</i>
                </div>
                <button type="danger" class="btn btn-outline-danger  my-2 my-sm-0" @click="alertDisplay(enrollment)">
                  <font-awesome-icon icon="trash" />
                </button>
              </td>
            </tr>
          </tbody>
        </table>
        <button data-toggle="modal" data-target="#smsModal" class="btn btn-primary">Отправить смс</button>
<div id="smsModal" class="mt-5 modal fade" role="dialog">
  <div class="modal-dialog">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col-4">
        <p>Отправить СМС</p>
          </div>
          <div class="col-6">
          <b-button v-b-toggle.collapse-1 class="mb-3">Список учеников</b-button>
  <b-collapse id="collapse-1" class="mt-2">
      <p v-for="enrollment in enrollments_enrolled"> <input type="checkbox" v-model="selected" :value="enrollment.id" number>{{ users[enrollment.user_id].name }}</p>
  </b-collapse>
          </div>
        </div>
        <input name="name" v-model="sourceData" class="form-control"/>
        <textarea name="text" class="form-control mt-3">Рассылка от Method digital education</textarea>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal">Отправить</button>
      </div>
    </div>

  </div>
</div>
    </div>
     </template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import Datepicker from 'vuejs-datepicker'
import JsonExcel from 'vue-json-excel'

export default {
  name: 'Enrolled',
  data() {
    return {
      json_fields: {
            'Name': 'name',
            'Phone': 'phone',
            'Email': 'email',
            'Course': 'course',
            'Group': 'group'
        },
        json_data: [
            {
                'name': '',
                'phone': '',
                'email': '',
                'course': '',
                'group': ''
            }
        ],
        json_meta: [
            [
                {
                    'key': 'charset',
                    'value': 'utf-8'
                }
            ]
        ],
      error: '',
      notice: '',
      users: {},
      phones: {},
      title: '',
      group: {
        title: '',
        course_id: '',
        instructor_id: '',
        start: '',
        end: ''
      },
      course_title: '',
      instructor: '',
      enrollment: '',
      enrollments: '',
      enrollments_enrolled: {
        status: ''
      },
      enrollments_dropped: {
        status: ''
      },
      enrollments_skipped: {
        status: ''
      },
      editedEnrollment: '',
      resource_url: `/${this.$store.getters.getCurrentCity.slug}/admin/groups/:slug`,
      paid: '',
      left: '',
      paid_days: '',
      paid_amount: '',
      paid_sum: '',
      overall_paid: '',
      overall_amount: '',
      tabs: ['Активные', 'Прошлые', 'Запланированные'],
      currentTab: 0,
      input: {
        phone: ''
      }, 
      selected: [],
      selectedSms: [],
      checked: false
    }
  },
  created() {
    this.$emit('update:layout', Admin)
    this.getGroup()
  },
  mounted: {
    enrolled(){
      return enrollments_enrolled.length
    }
  },
  computed: {
    sourceData (i) {
      let total = []     
      let lengthArr = this.selected.length
      let en
      for (i = 0; i < lengthArr; i++) {
        for (let j=0; j < this.enrollments_enrolled.length; j++){
          if(this.enrollments_enrolled[j].id===this.selected[i]){
            let user = this.enrollments_enrolled[j].user_id
            let phoneNum = this.users[user].phone
            total.push(phoneNum)
          }
        }
      } 
      return total
      },
    selectAll: {
      get: function () {
        return this.enrollments_enrolled ? this.selected.length == this.enrollments_enrolled.length : false;
      },
      set: function (value) {
        let selectedSms = []
        var selected = []
        if (value) {
          this.enrollments_enrolled.forEach(function (enrollment) {
            selected.push(enrollment.id)
            selectedSms.push(enrollment.user_id)
          })
          this.checked = true
        } else {
          this.checked = false
        }
        this.selected = selected
        this.selectedSms = selectedSms
      }
    }
  },
  methods: {
    getGroup() {
      if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/groups/${this.$route.params.slug}`)
          .then(response => {
            this.group = response.data.group
            this.enrollments_enrolled = response.data.enrollments_enrolled
            this.paid_days = response.data.paid_days
            this.paid_amount = response.data.paid_amount
            this.paid_sum = response.data.paid_sum
            this.overall_amount = response.data.overall_amount
            this.overall_paid = response.data.overall_paid
            this.instructor = response.data.instructor
            this.course_title = response.data.course_title
            this.users = response.data.users.reduce((acc, value) => {
              acc[value.id] = value
              return acc
            }, {})
            for(let i=0; i<this.enrollments_enrolled.length;i++) {
              this.json_data[i] = {}
              this.json_data[i] = this.users[this.enrollments_enrolled[i].user_id]
              this.json_data[i].course = this.course_title
              this.json_data[i].group = this.group.title
            }            
          })
          .catch(error => {
            this.setError(error, 'Ошибка')
          })
      } else {
        this.$router.replace('/')
      }
    },

    updateResource(data) {
      this.groups = data
    },
    showEnrollmentLink() {
      return this.$store.getters.isAdmin || this.$store.getters.isAdmin
    },
    setError(error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    editEnrollment(enrollment) {
      this.editedEnrollment = enrollment
    },
    updateEnrollment(enrollment) {
      if (this.editedEnrollment) {
        this.editedEnrollment = ''
        this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/enrollments/${enrollment.id}`, {
            enrollment: {
              status: enrollment.status
            }
          })
          .then(response => {
            switch (enrollment.status) {
              case 'enrolled':
                this.enrollments_dropped.splice(this.enrollments_dropped.indexOf(enrollment), 1)
                this.enrollments_skipped.splice(this.enrollments_skipped.indexOf(enrollment), 1)
                this.enrollments_enrolled.push(enrollment)
                break
              case 'dropped':
                this.enrollments_enrolled.splice(this.enrollments_enrolled.indexOf(enrollment), 1)
                this.enrollments_completed.splice(this.enrollments_completed.indexOf(enrollment), 1)
                this.enrollments_skipped.splice(this.enrollments_skipped.indexOf(enrollment), 1)
                this.enrollments_attending.splice(this.enrollments_attending.indexOf(enrollment), 1)
                this.enrollments_dropped.push(enrollment)
                break
              case 'skipped':
                this.enrollments_enrolled.splice(this.enrollments_enrolled.indexOf(enrollment), 1)
                this.enrollments_dropped.splice(this.enrollments_dropped.indexOf(enrollment), 1)
                this.enrollments_completed.splice(this.enrollments_completed.indexOf(enrollment), 1)
                this.enrollments_attending.splice(this.enrollments_attending.indexOf(enrollment), 1)
                this.enrollments_skipped.push(enrollment)
                break
            }
          })
          .catch(error => this.setError(error, 'Невозможно обновить группу'))
      } else {
        this.notice = ''
        this.error = ''
      }
    },
    removeEnrollment(enrollment) {
      this.$http.secured.delete(`/${this.$store.getters.getCurrentCity.slug}/admin/enrollments/${enrollment.id}`)
        .then(response => this.enrollments.splice(this.enrollments.indexOf(enrollment), 1))
        .catch(error => this.setError(error, 'Невозможно обновить группу'))
    },
    alertDisplay(group) {
      this.$swal({
        title: 'Вы уверены что хотите удалить?',
        type: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Да, удалить!',
        cancelButtonText: 'Нет, оставить!',
        showCloseButton: true,
        showLoaderOnConfirm: true
      }).then((result) => {
        if (result.value) {
          this.$swal('Deleted', 'Вы успешно удалили', 'success')
          this.removeEnrollment(group)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  directives: {
    'enrollment-focus': function(el) {
      el.focus()
    }
  },
  components: {
    Admin,
    Datepicker
  }
}
</script>
<style scoped>
.iconExcel {
  font-size: 1.2rem;
  color: green;
}
</style>