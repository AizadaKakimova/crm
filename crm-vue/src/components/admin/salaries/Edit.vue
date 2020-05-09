<template>
  <div class="Edit Salar">
    <b-alert  v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert  v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
      <form @submit.prevent="editSalary">
        <div class="form-group">
           salary: <input v-model="salary.monthly">
        </div>
        <div class="form-group">
          hourly: <input v-model="salary.hourly">
        </div>
        <div class="form-group">
          full_time: <input type="checkbox" id="checkbox" v-model="salary.full_time">
        </div>
        <button  type="submit" class="btn btn-warning mb-3">Edit Salary</button>
      </form>
  </div>
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'
export default {
  name: 'SalaryEdit',
  data () {
    return {
      error: '',
      notice: '',
      salary: {
        full_time: '',
        hourly: '',
        user_id: '',
        monthly: ''
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
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
    this.getSalary()
  },
  methods: {
    getSalary () {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/salaries/${this.$route.params.id}`, this.salary)
        .then(response => { this.salary = response.data })
        .catch(error => { this.setError(error, this.response.data.error) })
    },
    editSalary () {
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/salaries/${this.$route.params.id}`, this.salary)
        .then(response => { this.createSuccessful(response) })
        .catch(error => { this.setError(error, this.response.data.error) })
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createSuccessful (response) {
      this.notice = 'Зарплата обновлена'
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
  components: { Admin }
}
</script>
