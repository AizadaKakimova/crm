<template>
  <div class="New Group">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <form class="form-app form-edit" @submit.prevent="addGroup">
      <div class="form-group">
        Title: <input v-model="group.title">
      </div>
      <div class="form-group">
        <select class="form-control" v-model="group.instructor_id">
          <option v-for="instructor in instructors" v-bind:value="instructor.id" v-bind:key="instructor.id">{{
            instructor.name }}
          </option>
        </select>
      </div>
      <div class="form-group">
        <select class="form-control" v-model="group.course_id">
          <option v-if="course.visible" v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">
            {{ course.title }}
          </option>
        </select>
      </div>
      <div class="form-group">
        start:
        <datepicker v-model="group.start" name="start"></datepicker>
      </div>
      <div class="form-group">
        end:
        <datepicker v-model="group.end" name="end"></datepicker>
      </div>
      <button type="submit" class="btn btn-primary mb-3">Create</button>
      <div>
        <router-link to="/manager/groups">Back To groups List</router-link>
      </div>
    </form>
  </div>
</template>

<script>
import Manager from '@/components/layouts/manager/Manager'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'GroupNewManager',
  data () {
    return {
      error: '',
      notice: '',
      courses: '',
      instructors: '',
      group: {
        title: '',
        course_id: '',
        instructor_id: '',
        start: '',
        end: ''
      }
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    this.checkSignedIn()
    this.$http.secured.get('/manager/courses/')
      .then(response => {
        this.courses = response.data
      })
      .catch(error => {
        this.setError(error, 'Something went wrong')
      })
    this.$http.secured.get('/manager/users/instructors')
      .then(response => {
        this.instructors = response.data
      })
      .catch(error => {
        this.setError(error, 'Something went wrong')
      })
  },
  methods: {
    addGroup () {
      this.$http.secured.post('/manager/groups/new', this.group)
        .then(response => {
          this.createSuccessful(response)
        })
        .catch(error => {
          this.setError(error, 'Please, check lines!')
        })
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createSuccessful (response) {
      this.notice = 'Group Added'
      this.error = ''
    },
    createFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    checkSignedIn () {
      if (!(this.$store.state.signedIn && this.$store.getters.isManager)) {
        this.$router.replace('/')
      }
    }
  },
  components: {Manager, Datepicker}
}
</script>
