<template>
  <div class="New User">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <form class="form-app form-edit" @submit.prevent="addUser">
      <div class="form-group">
        name: <input v-model="user.name">
      </div>
      <div class="form-group">
        phone: <input v-model="user.phone">
      </div>
      <div class="form-group">
        email: <input v-model="user.email">
      </div>
      <div class="form-group">
        <select v-model="user.role" class="form-control" id="role">
          <option value='admin'>Admin</option>
          <option value='manager'>Manager</option>
          <option value='user'>User</option>
          <option value='instructor'>Instructor</option>
        </select>
      </div>
      <button type="submit" class="btn btn-primary mb-3">Create</button>
    </form>
  </div>
</template>
<script>
import Manager from '@/components/layouts/manager/Manager'

export default {
  name: 'UserNew',
  data () {
    return {
      error: '',
      notice: '',
      user: {
        name: '',
        phone: '',
        email: '',
        role: 'user'
      }
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    this.checkSignedIn()
  },
  methods: {
    addUser () {
      this.$http.secured.post('/manager/user/new', this.user)
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
      this.notice = 'User Added'
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
