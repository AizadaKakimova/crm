<template>
<div class="row">
  <div class="col-md-5 mx-auto">
    <b-alert  v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert  v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <b-card header = "Новая группа" class ="card">
    <form class="form-app form-edit" @submit.prevent="addGroup">
      <div class="form-group">
         Название: <input type="text" v-model="group.title" autocomplete="off" class="form-control mr-sm-2" id="input-icon-left" name="input-icon-left" required/>
      </div>
      <div class="form-group mt-3" >
        Преподаватель:
        <select class="form-control" v-model="group.instructor_id">
          <option v-for="instructor in instructors" v-bind:value="instructor.id" v-bind:key="instructor.id">{{ instructor.name }}</option>
        </select>
      </div>
      <div class="form-group mt-3">
        Курс:
        <select class="form-control" v-model="group.course_id">
          <option v-if="course.visible" v-for="course in courses"  v-bind:value="course.id" v-bind:key="course.id">
            {{ course.title }}
          </option>
        </select>
      </div>
      <div class="form-group mt-3" >
        Филиал:
        <select class="form-control" v-model="group.branch_id">
          <option v-for="branch in branches" v-bind:value="branch.id" v-bind:key="branch.id">{{ branch.name }}</option>
        </select>
      </div>
      <div class ="form-group mt-3">
          Дата:
          <datepicker v-model="group.start" name="start" placeholder="Дата начала" id="date"></datepicker>
              <div class="form-group mt-3">
          <datepicker v-model="group.end" placeholder="Дата окончания" name="end" id="date2"></datepicker>
        </div>
        </div>
      <button type="submit" class="btn btn-primary mb-3">Создать</button>
      <div>
        <router-link to="/admin/groups/">Назад к таблице Групп</router-link>
      </div>
    </form>
    </b-card>
  </div>

  </div>
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'GroupNew',
  data () {
    return {
      error: '',
      notice: '',
      courses: '',
      instructors: '',
      groups: [],
      group: {
        title: '',
        course_id: '',
        instructor_id: '',
        start: '',
        end: '',
        day: '',
        time: [],
        city_id: 1,
        branch_id: ''
      }
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
    this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses`)
      .then(response => {
        this.courses = response.data.courses
        this.branches = response.data.branches
      })
      .catch(error => { this.setError(error, 'Что-то пошло не так') })
    this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/instructors`)
      .then(response => { this.instructors = response.data })
      .catch(error => { this.setError(error, 'Что-то пошло не так') })
  },
  methods: {
    addGroup () {
      this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/groups/new`, this.group)
        .then(response => { this.createSuccessful(response) })
          .catch(error => { this.setError(error, 'Пожалуйста, проверьте поля!') })
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createSuccessful (response) {
      this.notice = 'Группа добавлена'
      this.error = ''
    },
    createFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    checkSignedIn () {
      if (!(this.$store.state.signedIn && this.$store.getters.isAdmin)) {
        this.$router.replace('/')
      }
    }
  },
  components: { Admin, Datepicker }
}
</script>
<style scoped>
li {
  display: inline-block;
  margin-right: 1.8rem;
}

/* .collapse, #monday,
#tue, #wed, #thu, #fri {
  font-size: 0.75rem;
} */
</style>