<template>
    <div class="groups col-md-10">
      <b-card header = "Группы">
      <b-alert  v-if="error" show dismissible variant="danger">
        {{ error }}
      </b-alert>
      <b-alert  v-if="notice" show dismissible variant="success">
        {{ notice  }} {{dismissCountDown}}
      </b-alert>
        <div class="row">
          <div class="col-md-5">
      <h2>{{userName}}</h2>
      <form @submit.prevent="addAttendance">
        <div class="form-group">
          Дата: <datepicker v-model="newAttend.day" name="day"></datepicker>
        </div>
        <button class="btn btn-outline-primary" type="submit">Добавить</button>
      </form>
            </div>
          <div class="col-md-6">
      <table class="table">
        <thead>
          <tr>
            <th>N</th>
            <th>Дата</th>
            <th>Действие</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(attend, index) in attendances" :key='attend.id' :request="attend">
            <td id="index">
              {{index}}
            </td>
            <td>
                  {{attend.day | formatDate}}
            </td>
            <td>
              <font-awesome-icon class="red" icon="trash" type="button" @click="alertDisplay(attend)"/>
            </td>
          </tr>
        </tbody>
      </table>
            </div>
          </div>
        </b-card>
    </div>
</template>
<script>
import Instructor from '@/components/layouts/instructor/Instructor.vue'
import Datepicker from 'vuejs-datepicker'
export default {
  name: 'AttendanceShow',
  data () {
    return {
      error: '',
      notice: '',
      userName: '',
      date: new Date(),
      attendance: [],
      attendances: '',
      group: {
        title: ''
      },
      enrollment: '',
      newAttend: {
        day: '',
        enrollment_id: ''

      }
    }
  },
  watch: {
    '$route': 'getGroup'
  },
  created () {
    this.$emit('update:layout', Instructor)
    this.getAttendances()
  },
  methods: {
    getAttendances () {
      if (this.$store.state.signedIn && this.$store.getters.isInstructor) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/instructor/attendances/${this.$route.params.id}`)
          .then(response => {
            this.attendances = response.data.attendances
            this.enrollment = response.data.enrollment
            this.userName = response.data.user_name
          })
          .catch(error => { this.setError(error, 'Error') })
      } else {
        this.$router.replace('/')
      }
    },
    alertDisplay (attend) {
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
          this.removeAttendance(attend)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    },
    removeAttendance (attend) {
      this.$http.secured.delete(`/instructor/attendances/${attend.id}`)
        .then(response => {
          this.attendances.splice(this.attendances.indexOf(attend), 1)
          this.notice = 'deleted'
        })
        .catch(error => this.setError(error, 'Cannot delete this day'))
    },
    addAttendance () {
      this.newAttend.enrollment_id = this.enrollment.id
      this.$http.secured.put(`/instructor/attendance/new`, this.newAttend)
        .then(response => {
          this.newAttend.day = ''
          this.createAttendSuccessful(response)
          this.getAttendances()
        })
        .catch(error => { this.setError(error, 'Not checked!') })
    },
    updateResource (data) {
      this.groups = data
    },
    setError (error, text, index) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createAttendSuccessful (response) {
      this.notice = 'Checked'
      this.error = ''
    },
    createSuccessful (response, name, coins) {
      this.notice = name + ' you earned ' + coins + ' coins!'
      this.error = ''
    },
    editEnrollment (enrollment) {
      this.editedEnrollment = enrollment
    }
  },
  components: {Instructor, Datepicker }
}
</script>
<style scoped>
.btn {
    border-radius: 0px!important;
  }
</style>
