<template>
  <div class="requests col-md-8">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <form class="form-app form-edit" @submit.prevent="update">
      <div class="form-group">
        <label>{{ request.id }}</label>
      </div>
      <div class="form-group">
        <label>Name - {{ request.name }}</label>
      </div>
      <div class="form-group">
        <input v-model="request.email">
      </div>
      <div class="form-group">
        <select v-model="request.status" class="form-control" id="status">
          <option value='new'>new</option>
          <option value='processed'>processed</option>
          <option value='pending'>pending</option>
          <option value='enrolled'>enrolled</option>
        </select>
      </div>
      <div class="form-group">
        <label>Source</label>
        <select v-model="request.source" class="form-control" id="source">
          <option value='Поисковик'>Поисковик</option>
          <option value='Соц сети'>Соц сети</option>
          <option value='Рекомендация'>Рекомендация</option>
          <option value='Рассылка'>Рассылка</option>
          <option value='Биллбоард'>Биллбоард</option>
          <option value='Другое'>Другое</option>
        </select>
      </div>
      <button type="submit" class="btn btn-primary mb-3">Update</button>
      <button v-if="request.status === 'enrolled'" type="button" class="btn btn-info mb-3" @click="accept()">Accept
      </button>
      <div>
        <router-link to="/manager/requests">Back To Requests</router-link>
      </div>
    </form>
  </div>
</template>
<script>
import Manager from '@/components/layouts/manager/Manager'

export default {
  name: 'RequestShowManager',
  data () {
    return {
      error: '',
      notice: '',
      request: {}
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    this.checkSignedIn()
  },
  methods: {
    update () {
      this.$http.secured.patch(`/manager/requests/${this.$route.params.id}`, {
        request: {
          status: this.request.status,
          source: this.request.source
        }
      })
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateSuccessful (response) {
      this.notice = 'Request updated'
      this.error = ''
      // this.$router.go('/admin/requests')
    },
    createSuccessful (response) {
      this.notice = 'User added'
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
        this.$http.secured.get(`/manager/requests/${this.$route.params.id}`)
          .then(response => {
            if (this.$store.getters.currentUserId === response.data.id) {
              this.$router.replace('/')
              return
            }
            this.request = response.data
          })
          .catch(error => {
            this.setError(error, 'Something went wrong')
          })
      } else {
        this.$router.replace('/')
      }
    },
    accept () {
      this.$http.secured.post('/manager/user/new', {
        name: this.request.name,
        email: this.request.email,
        phone: this.request.phone,
        role: 'user'
      })
        .then(response => {
          this.createSuccessful(response)
        })
        .catch(error => {
          this.setError(error, 'Please, check lines!')
        })
    }
  },
  components: {Manager}
}
</script>
