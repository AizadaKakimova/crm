<template>
  <div class="New Enrollment">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <form class="form-app form-edit" @submit.prevent="addEnrollment">
      <div class="form-group">
        User ID: <input type='number' v-model="enrollment.user_id">
      </div>
      <div class="form-group">
        Group: <input type='number' v-model="enrollment.group_id">
      </div>
      <div class="form-group">
        Expected value: <input v-model="enrollment.expected_value">
      </div>
      <div class="form-group">
        <select class="form-control" v-model="enrollment.status">
          <option value='skipped'>skipped</option>
          <option value='dropped'>dropped</option>
          <option value='attending'>attending</option>
          <option value='enrolled'>enrolled</option>
          <option value='completed'>completed</option>
        </select>
      </div>
      <button type="submit" class="btn btn-primary mb-3">Create</button>
      <div>
        <router-link to="/manager/users">Back To group</router-link>
      </div>
    </form>
  </div>
</template>

<script>
import Manager from '@/components/layouts/manager/Manager'

export default {
  name: 'EnrollmentNewManager',
  data () {
    return {
      error: '',
      notice: '',
      enrollment: {
        user_id: '',
        group_id: '',
        status: '',
        expected_value: ''
      }
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    this.checkSignedIn()
  },
  methods: {
    addEnrollment () {
      this.$http.secured.post('/manager/enrollments/new', this.enrollment)
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
      this.notice = 'Student Added'
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
