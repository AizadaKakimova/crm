<template>
  <div class="Edit Salar">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <form @submit.prevent="addSalary">
      <input type="hidden" :model="salary.user_id = this.$route.params.id">
      <div class="form-group">
        salary: <input v-model="salary.monthly">
      </div>
      <div class="form-group">
        hourly: <input v-model="salary.hourly">
      </div>
      <div class="form-group">
        full_time: <input type="checkbox" id="checkbox" v-model="salary.full_time">
      </div>
      <button type="submit" class="btn btn-primary mb-3">Add Salary</button>
    </form>
  </div>
</template>

<script>
import Manager from '@/components/layouts/manager/Manager'

export default {
  name: 'SalaryNewManager',
  data () {
    return {
      loading: false,
      error: '',
      notice: '',
      salary: {
        full_time: false,
        hourly: 0,
        user_id: '',
        monthly: 0
      },
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
    addSalary () {
      this.$http.secured.post('/manager/salaries/new', this.salary)
        .then(response => {
          this.createSuccessful(response)
        })
        .catch(error => {
          this.setError(error, this.response.data.error)
        })
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createSuccessful (response) {
      this.notice = 'Salary Added'
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
