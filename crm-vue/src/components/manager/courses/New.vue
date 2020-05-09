<template>
  <div class="New Course">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <form class="form-group" @submit.prevent="addCourse">
      <b-form-group type="name" id="name" label="Название нового курса" label-for="name">
        <b-form-input id="input" v-model.trim="course.title"></b-form-input>
      </b-form-group>
      <b-form-group type="name" id="file" label="Название файла" label-for="file">
        <b-form-input id="input3" v-model.trim="course.file_name"></b-form-input>
      </b-form-group>
      <b-form-group label="Цена">
        <b-form-input id="input1" type="number" v-model.trim="course.price"></b-form-input>
      </b-form-group>
      <b-form-group label="Slug">
        <b-form-input required id="input1" type="text" v-model.trim="course.slug"></b-form-input>
      </b-form-group>
      <button type="submit" class="btn btn-primary mb-3">Create</button>
      <div>
        <router-link to="/manager/courses">Back To Course List</router-link>
      </div>
    </form>
  </div>
</template>

<script>
import Manager from '@/components/layouts/manager/Manager'

export default {
  name: 'CourseNewManager',
  data () {
    return {
      error: '',
      notice: '',
      course: {
        title: '',
        file_name: '',
        price: '',
        slug: ''
      }
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    this.checkSignedIn()
  },
  methods: {
    addCourse () {
      this.$http.secured.post('/manager/courses/new', this.course)
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
      this.notice = 'Course Added'
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
  components: {Manager}
}
</script>
