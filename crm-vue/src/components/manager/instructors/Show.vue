<template>
  <b-container class="col-md-10">
    <breadcrumb></breadcrumb>

    <b-row class="instructor">
      <b-col class="col-md-6">
        <b-alert v-if="error" show dismissible ariant="alert">
          {{ error }}
        </b-alert>
        <b-alert v-if="notice" show dismissible ariant="success">
          {{ notice }}
        </b-alert>
        <form class="form-app form-edit">
          <div class="form-group">
            <h3>Role: {{ user.role}}</h3>
          </div>
          <div class="form-group">
            <h4>Name: {{ user.name }}</h4>
          </div>
          <div class="form-group">
            <h4>Email: {{ user.email }}</h4>
          </div>
          <div class="form-group">
            <h4>Phone: {{ user.phone }}</h4>
          </div>
          <div>
            <router-link to="/manager/instructors">Back To Instructors</router-link>
          </div>
        </form>
      </b-col>
      <b-col class="col-md-6">
        <h4>Hours this month: {{ teaching_hours }}</h4>
        <div v-if="salary">
          <span class="btn btn-success" v-if="salary">Salary this month: {{ (teaching_hours*salary.hourly) + salary.monthly }}</span>
          <router-link :to="`/manager/instructors/${this.user.id}/salaries/${this.salary.id}`"
                       class="btn btn-md btn-warning">Edit Salary
          </router-link>
        </div>
        <router-link v-else :to="`/manager/instructors/salaries/${this.user.id}`" class="btn btn-md btn-primary">New
          Salary
        </router-link>
        <div v-if="groups.length">
          <h2>Groups</h2>
          <p v-for="group in groups" :key="group.id">
            <router-link :to="`/manager/groups/${group.slug}`">
              {{ group.title }}
            </router-link>
            from: {{ group.start | formatDate }} to {{ group.end | formatDate }}
          <ul>
            <li>Enrolled: {{ enrollments[group.id].enrolled }}</li>
            <li>Dropped: {{ enrollments[group.id].dropped }}</li>
            <li>Skipped: {{ enrollments[group.id].skipped }}</li>
            <li>Complited: {{ enrollments[group.id].complited }}</li>
            <li>attending: {{ enrollments[group.id].attending }}</li>
          </ul>
          </p>
        </div>
        <div v-else>
          <h3>No groups</h3>
        </div>
      </b-col>
    </b-row>
  </b-container>
</template>
<script>
import Manager from '@/components/layouts/manager/Manager'
import Breadcrumb from '@/components/Breadcrumbs'

export default {
  name: 'InstructorsShowManager',
  data () {
    return {
      error: '',
      notice: '',
      enrollments: '',
      groups: [],
      teaching_hours: '',
      requests: '',
      salary: null,
      user: {
        name: '',
        phone: '',
        email: '',
        birthdate: '',
        school: ''
      }
    }
  },
  watch: {
    '$route' () {
      this.breadcrumbList = this.$route.meta.breadcrumb
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    this.checkSignedIn()
    this.$http.secured.get(`/manager/instructors/${this.$route.params.id}`)
      .then(response => {
        this.user = response.data.instructor
        this.groups = response.data.groups
        this.salary = response.data.salary
        this.enrollments = response.data.enrollments
        this.teaching_hours = response.data.teaching_hours
      })
      .catch(error => this.updateFailed(error))
  },
  methods: {
    update () {
      this.$http.secured.patch(`/manager/instructors/${this.$route.params.id}`, {
        user: {
          role: this.user.role,
          name: this.user.name,
          email: this.user.email,
          phone: this.user.phone,
          birthdate: this.user.birthdate,
          school: this.user.school
        }
      })
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateSuccessful (response) {
      this.notice = 'Instructor updated'
      this.error = ''
    },
    updateFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
      this.notice = ''
    },
    checkSignedIn () {
      if (this.$store.state.signedIn && this.$store.getters.isManager) {
        this.$http.secured.get(`/manager/users/${this.$route.params.id}`)
          .then(response => {
            this.user = response.data.user
          })
          .catch(error => {
            this.setError(error, 'Something went wrong')
          })
      } else {
        this.$router.replace('/')
      }
    }
  },
  components: {Manager, Breadcrumb}
}
</script>
