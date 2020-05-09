<template>
  <div class="Edit Salary col-6 mx-auto mt-5">
    <b-alert  v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert  v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <b-card header="Новая зарплата" class="card">
      <form @submit.prevent="addSalary">
        <input type="hidden" :model="salary.user_id = this.$route.params.id" >
        <div class="form-group">
           Зарплата: <input v-model="salary.monthly">
        </div>
        <div class="form-group">
          Часы: <input v-model="salary.hourly">
        </div>
        <div class="form-group">
          Фулл-тайм: <input type="checkbox" id="checkbox" v-model="salary.full_time">
        </div>
        <button  type="submit" class="btn btn-primary mb-3">Добавить зарплату</button>
      </form>
  </b-card>
  </div>
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'
export default {
  name: 'SalaryNew',
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
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
  },
  methods: {
    addSalary () {
      this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/salaries/new`, this.salary)
        .then(response => { this.createSuccessful(response) })
        .catch(error => { this.setError(error, this.response.data.error) })
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createSuccessful (response) {
      this.notice = 'Зарплата добавлена'
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
