<template>
  <b-container class="col-md-8">
    <breadcrumb></breadcrumb>
    <b-row class="users">
      <b-col class="col-md-6">
        <b-alert v-if="error" show dismissible ariant="alert">
          {{ error }}
        </b-alert>
        <b-alert v-if="notice" show dismissible ariant="success">
          {{ notice }}
        </b-alert>
        <form class="form-app form-edit" @submit.prevent="update">
          <div class="form-group">
            name: <input v-model="user.name" placeholder="user.name"/>
          </div>
          <div class="form-group">
            email: <input v-model="user.email" placeholder="user.email"/>
          </div>
          <div class="form-group">
            phone: <input v-model="user.phone" placeholder="phone"/>
          </div>
          <div class="form-group">
            birthdate:
            <datepicker v-model="user.birthdate"></datepicker>
          </div>
          <div class="form-group">
            school: <input v-model="user.school" placeholder="school"/>
          </div>
          <div class="form-group">
            role: <select v-model="user.role" class="form-control" id="role">
            <option value='admin'>Admin</option>
            <option value='manager'>Manager</option>
            <option value='user'>User</option>
            <option value='instructor'>Instructor</option>
          </select>
          </div>
          <button type="submit" class="btn btn-primary mb-3">Update</button>
          <div>
            <router-link to="/manager/users">Back To Users List</router-link>
          </div>
        </form>
      </b-col>
      <b-col>
        <div v-if="groups.length">
          <h2>Groups</h2>
          <p v-for="group in groups" :key="group.id">
            <router-link :to="`/manager/groups/${group.slug}`">
              {{ group.title }}
            </router-link>
          </p>
        </div>
        <div v-else>
          <h3>No groups</h3>
        </div>
        <div v-if="requests.length">
          <h2>Requests</h2>
          <p v-for="request in requests" :key="request.id">
            <router-link :to="`/manager/requests/${request.id}`">
              {{ request.created_at | formatDate }}
            </router-link>
          </p>
        </div>
        <div v-else>
          <h3>No requests</h3>
        </div>
      </b-col>
    </b-row>
  </b-container>
</template>
<script>
import Manager from '@/components/layouts/manager/Manager'
import Breadcrumb from '@/components/Breadcrumbs'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'UserEdit',
  data () {
    return {
      error: '',
      notice: '',
      enrollments: '',
      groups: [],
      requests: '',
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
    this.$emit('update:layout', Manager)
    this.checkSignedIn()
    this.$http.secured.get(`/manager/users/${this.$route.params.id}`)
      .then(response => {
        this.user = response.data.user
        this.enrollments = response.data.enrollments
        this.groups = response.data.groups
        this.requests = response.data.requests
      })
      .catch(error => this.updateFailed(error))
  },
  methods: {
    update () {
      this.$http.secured.patch(`/manager/users/${this.$route.params.id}`, {
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
      this.notice = 'User updated'
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
  components: {Manager, Datepicker, Breadcrumb}
}
</script>
