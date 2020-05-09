<template>
<div class="groups col-md-12">
  <b-alert v-if="error" show dismissible ariant="alert">
    {{ error }}
  </b-alert>
  <div class="groups col-md-4">
  </div>
  <div class="groups col-md-12">
    <b-card class="card">
        <p class="pGroup"><font-awesome-icon icon="university" style="width: 2rem" class="iconsGroup"/> <strong>{{ group.title }}</strong></p>
        <p class="pGroup"><font-awesome-icon icon="book" style="width: 2rem" class="iconsGroup"/> <strong>{{ course_title }}</strong></p>
        <p class="pGroup"><font-awesome-icon icon="chalkboard-teacher" style="width: 2rem" class="iconsGroup"/> <strong>{{ instructor.name }}</strong></p>
      <p class="pGroup"><font-awesome-icon :icon="['fas', 'calendar-alt']" style="width: 2rem" class="iconsGroup"/><strong>{{ group.start | formatDate }}</strong> до <strong>{{ group.end | formatDate }}</strong></p>
      <br />
      <router-link :to="`/admin/groups/${this.$route.params.slug}/enrollments/new`" class="btn btn-primary">
        <font-awesome-icon icon="plus-square" /> Добавить
      </router-link>
      <router-link :to="`/admin/groups/${this.$route.params.slug}/edit`" class="btn btn-success">
        <font-awesome-icon icon="pencil-alt" />
      </router-link>
   <b-tabs pills card class="tabs">
     <b-tab title="Зачислено"><Enrolled/></b-tab>
      <b-tab title="Сбросано"><Dropped/></b-tab>
      <b-tab title="Пропущено"><Skipped/></b-tab>
    </b-tabs>
      <p>Ожидаемая сумма: {{overall_amount}}</p>
      <p>Полученнная сумма: {{overall_paid}}</p>

      <div>
        <router-link to="/admin/groups">Назад к таблице Групп</router-link>
      </div>
      <div class="col-md-12" @click="updateEnrollment(editedEnrollment)" style="height: 35%"></div>
    </b-card>
  </div>
</div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import Enrolled from '@/components/admin/groups/groupShow/Enrolled'
import Dropped from '@/components/admin/groups/groupShow/Dropped'
import Skipped from '@/components/admin/groups/groupShow/Skipped'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'GroupShow',
  data() {
    return {
      error: '',
      notice: '',
      users: {},
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
      resource_url: '/admin/groups/:slug',
      paid: '',
      left: '',
      input: {
        name: "k", // or pre-fill with other default value like `lorem`

      },
      paid_days: '',
      paid_amount: '',
      paid_sum: '',
      overall_paid: '',
      overall_amount: ''
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
  methods: {
    getGroup() {
      if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/groups/${this.$route.params.slug}`)
          .then(response => {
            this.group = response.data.group
            this.enrollments_enrolled = response.data.enrollments_enrolled
            this.enrollments_dropped = response.data.enrollments_dropped
            this.enrollments_skipped = response.data.enrollments_skipped
            this.enrollments_completed = response.data.enrollments_completed
            this.enrollments_attending = response.data.enrollments_attending
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
            // alert(this.users[this.enrollments_enrolled[0].user_id].name )
            // this.json_data[0].name = this.users[this.enrollments_enrolled[0].user_id].name 
            // alert(this.json_data[0].name)
          })
          .catch(error => {
            this.setError(error, 'Error')
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
        .catch(error => this.setError(error, 'Невозможно удалить зачисления'))
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
    Datepicker,
    Enrolled,
    Dropped,
    Skipped,
  }
}
</script>
<style>
.tabs .card-header{
  background-color: transparent;
  border-bottom: none;
  margin-left: 60%;
}
.nav-pills .nav-item .nav-link{
  color: #007bff;
  border: 1px solid #007bff;
  font-size: 1rem;
}
.nav-pills .nav-item .nav-link:hover,  .mr-5:hover{
  color: #fff;
  background-color: #007bff;
}
.nav-pills .nav-link.active, .nav-pills .show>.nav-link{
  color: #fff;
}
.iconsGroup{
  filter: opacity(50%);
}
.pGroup{
  line-height: 0px;
}
</style>
