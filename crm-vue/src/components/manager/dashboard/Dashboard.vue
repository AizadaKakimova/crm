<template>
  <div class="dashboard col-md-8">
    <ul>
      <li>
        <router-link :to="`/manager/users`">
          Users {{ users }}
        </router-link>
      </li>
      <li>
        <router-link :to="`/manager/requests`">
          New requests {{ requests }}
        </router-link>
      </li>
      <li>
        <router-link :to="`/manager/instructors`">
          Instructors
        </router-link>
      </li>
      <li>Setting</li>
      <li>Analytics</li>
    </ul>
  </div>
</template>
<script>
import Manager from '@/components/layouts/manager/Manager'

export default {
  name: 'ManagerDash',
  data () {
    return {
      error: '',
      notice: '',
      users: '',
      requests: ''
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    this.checkSignedIn()
    if (this.$store.state.signedIn && this.$store.getters.isManager) {
      this.$http.secured.get('/manager/dashboard')
        .then(response => {
          this.users = response.data.users
          this.requests = response.data.requests
        })
        .catch(error => {
          this.setError(error, 'Something went wrong')
        })
    }
  },
  methods: {
    checkSignedIn () {
      if (this.$store.state.signedIn && this.$store.getters.isManager) {
        this.$http.secured.get(`/manager/dashboard`)
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
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
      this.notice = ''
    }
  },
  components: {Manager}
}
</script>
