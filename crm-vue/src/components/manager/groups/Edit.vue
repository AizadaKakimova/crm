<template>
  <div class="groups col-md-10">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <h3>Группа {{ group.title }}</h3>
    <td>
      <form class="form-app form-edit" @submit.prevent="updateGroup">
        <h2>Editing</h2>
        <div class="form-group">
          Title: <input type="text" v-model="group.title">
        </div>
        <div class="form-group">
          Instructor: <select class="form-control" v-model="group.instructor_id">
          <option v-for="instructor in instructors" v-bind:value="instructor.id" v-bind:key="instructor.id">{{
            instructor.name }}
          </option>
        </select>
        </div>
        <div class="form-group">
          Course: <select class="form-control" v-model="group.course_id" placeholder="group.course_id">
          <option v-if="course.visible" v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">{{
            course.title }}
          </option>
        </select>
        </div>
        <div class="form-group">
          start:
          <datepicker v-model="group.start" name="start">{{ group.start | formatDate }}</datepicker>
        </div>
        <div class="form-group">
          end:
          <datepicker v-model="group.end" name="end">{{ group.end | formatDate }}</datepicker>
        </div>
        <button type="submit" class="btn btn-primary mb-3">Update</button>
      </form>
      <div>
        <router-link to="`/manager/groups/${group.slug}`">Back To groups |</router-link>
        <router-link to="/manager/groups">| Back To groups List</router-link>
      </div>
    </td>
  </div>
</template>
<script>
import Manager from '@/components/layouts/manager/Manager'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'GroupEditManager',
  data () {
    return {
      error: '',
      notice: '',
      users: {},
      title: '',
      group: {
        title: '',
        start: '',
        end: ''
      },
      instructors: [],
      courses: [],
      resource_url: '/manager/groups/:slug'
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    if (this.$store.state.signedIn && this.$store.getters.isManager) {
      this.$http.secured.get(`/manager/groups/${this.$route.params.slug}`)
        .then(response => {
          this.group = response.data.group
          this.enrollments_enrolled = response.data.enrollments_enrolled
          this.enrollments_dropped = response.data.enrollments_dropped
        })
        .catch(error => {
          this.setError(error, 'Error')
        })
      this.$http.secured.get('/manager/users')
        .then(response => {
          this.users = response.data.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
      this.$http.secured.get('/manager/users/instructors')
        .then(response => {
          this.instructors = response.data
        })
        .catch(error => {
          this.setError(error, 'Something went wrong')
        })
      this.$http.secured.get('/manager/courses')
        .then(response => {
          this.courses = response.data.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    updateGroup () {
      this.$http.secured.patch(`/manager/groups/${this.$route.params.slug}`, this.group)
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateSuccessful (response) {
      this.notice = 'Group details have updated'
      this.error = ''
    },
    updateFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    updateResource (data) {
      this.groups = data
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    alertDisplay (group) {
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
          this.$swal('Deleted', 'You successfully deleted this file', 'success')
          this.removeEnrollment(group)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  directives: {
    'enrollment-focus': function (el) {
      el.focus()
    }
  },
  components: {Manager, Datepicker}
}
</script>
