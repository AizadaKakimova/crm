<template>
  <b-container class="col-md-10">
  <b-row class="instructor">
    <b-col class="col-md-6">
      <b-alert  v-if="error" show dismissible ariant="alert">
        {{ error }}
      </b-alert>
      <b-alert  v-if="notice" show dismissible ariant="success">
        {{ notice }}
      </b-alert>
      <form class="form-app form-edit">
        <div class="form-group">
          <h3>Role:  {{ user.role}}</h3>
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
          <!-- <router-link to="/admin/instructors">Back To Instructors</router-link> -->
        </div>
      </form>
    </b-col>
    <b-col class="col-md-6">
    <h4>Hours this month: {{ teaching_hours }}</h4>
    <div v-if="groups.length">
      <h2>Groups</h2>
      <p v-for="group in groups" :key="group.id">
        <router-link :to="`/instructor/groups/${group.slug}`">
          {{ group.title }}
        </router-link>
        from: {{ group.start | formatDate }} to {{ group.end | formatDate }}
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
import Instructor from '@/components/layouts/instructor/Instructor.vue'

export default {
  name: 'InstructorsShow',
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
  created () {
    this.$emit('update:layout', Instructor)
    this.checkSignedIn()
    this.$http.secured.get(`/instructor/users/${this.$store.getters.currentUserId}`)
      .then(response => {
        this.user = response.data.user
        this.groups = response.data.groups
        this.teaching_hours = response.data.teaching_hours
      })
      .catch(error => this.updateFailed(error))
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
      this.notice = ''
    },
    checkSignedIn () {
      if (this.$store.state.signedIn && this.$store.getters.isInstructor) {
        this.$http.secured.get(`/instructor/users/${this.$store.getters.currentUserId}`)
          .then(response => {
            this.user = response.data.user
          })
          .catch(error => { this.setError(error, 'Something went wrong') })
      } else {
        this.$router.replace('/')
      }
    }
  },
  components: { Instructor }
}
</script>
