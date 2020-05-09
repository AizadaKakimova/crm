<template>
  <div class="Edit Course">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <form class="form-app form-edit" @submit.prevent="update">
      <div class="form-group">
        Course title: <input type='text' v-model="course.title">
      </div>
      <div class="form-group">
        Price: <input type='number' v-model="course.price">
      </div>
      <div class="form-group">
        Slug: <input required type='text' v-model="course.slug">
      </div>
      <div class="form-group">
        Availablity:
      </div>
      <div class="form-group">
        <select class="form-control" v-model="course.visible">
          <option value='true'>Available</option>
          <option value='false'>Not available</option>
        </select>
      </div>
      <div class="form-group">
        Show in /courses:
      </div>
      <div class="form-group">
        <input type="checkbox" id="checkbox" v-model="course.shown"><label for="checkbox">Show</label>
      </div>
      <button type="submit" class="btn btn-primary mb-3">Update</button>
      <div>
        <router-link :to="`/manager/courses`">Back To course</router-link>
      </div>
    </form>
  </div>
</template>

<script>
import Manager from '@/components/layouts/manager/Manager'

export default {
  name: 'CourseEditManager',
  data () {
    return {
      error: '',
      notice: '',
      course: {
        title: '',
        price: '',
        slug: '',
        visible: ''
      },
      courses: [],
      editedCourse: '',
      resource_url: '/manager/course/:id'
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    if (this.$store.state.signedIn && this.$store.getters.isManager) {
      this.$http.secured.get(`/manager/courses/${this.$route.params.id}`)
        .then(response => {
          this.course = response.data.course
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
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    update () {
      this.$http.secured.patch(`/manager/courses/${this.$route.params.id}`, this.course)
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateSuccessful (response) {
      this.notice = 'Course updated'
      this.error = ''
    },
    updateFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    }
  },
  directives: {
    'enrollment-focus': function (el) {
      el.focus()
    }
  },
  components: {Manager}
}
</script>
<style lang="css">
</style>
