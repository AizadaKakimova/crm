<template>
  <div class="New Enrollment">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <h4> Оплачено: {{paid}}</h4>
    <h4> Осталось: {{left}}</h4>
    <h4>Paid days: {{paid_days}}</h4>
    <div class="row">
      <div class="col-sm">
        <form class="form-app form-edit" @submit.prevent="update">
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
          <button type="submit" class="btn btn-primary mb-3">Update</button>
          <div>
            <!-- <button onclick="goBack()">Go Back</button> -->
            <input class="btn btn-link" type="button" value="Back" onclick="history.back()">
          </div>
        </form>
      </div>
      <div class="col-sm">
        <form class="form-app form-edit" @submit.prevent="pay">
          <div class="form-group">
            <input type='hidden' :model="payment.enrollment_id = this.$route.params.id">
          </div>
          <div class="form-group">
            <input type='hidden' :model="payment.receiver_id = this.$store.getters.currentUserId">
          </div>
          <div class="form-group">
            Сумма оплаты: <input placeholder="Введите сумму" type='number' v-model="payment.sum">
          </div>

          <button v-if="payment.sum > 0" type="submit" class="btn btn btn-sm btn-success btn-secondary">Pay</button>
          <button v-if="payment.sum < 0" type="submit" class="btn btn btn-sm btn-danger btn-secondary">Возварт</button>
        </form>
      </div>
    </div>
    <table class="table" ref="thetable">
      <thead>
      <tr>
        <th>Сумма</th>
        <th>Получатель</th>
        <th>Дата</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="payment in payments" :key="payment.id">
        <td> {{ payment.sum }}</td>
        <td>{{ users[payment.receiver_id].name }}</td>
        <td>{{payment.created_at | formatDate}}</td>
      </tr>
      </tbody>
    </table>
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
        created_at: '',
        expected_value: ''
      },
      payments: [],
      payment: {
        sum: '',
        enrollment_id: '',
        receiver_id: '',
        created_at: ''
      },
      users: [],
      paid: '',
      left: '',
      paid_days: ''
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    this.checkSignedIn()
    this.$http.secured.get(`/manager/enrollments/${this.$route.params.id}`)
      .then(response => {
        this.enrollment = response.data.enrollment
        this.payments = response.data.payments
        this.paid = response.data.paid
        this.left = response.data.left
        this.paid_days = response.data.paid_days
      })
      .catch(error => {
        this.setError(error, 'Please, check the lines!')
      })
    this.$http.secured.get('/manager/users')
      .then(response => {
        this.users = response.data.reduce((acc, value) => {
          acc[value.id] = value
          return acc
        }, {})
      })
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
    update () {
      this.$http.secured.patch(`/manager/enrollments/${this.$route.params.id}`, this.enrollment)
        .then(response => {
          this.updateSuccessful(response)
        })
        .catch(error => {
          this.setError(error, 'Please, check lines!')
        })
    },
    goBack () {
      window.history.back()
    },
    pay () {
      this.$http.secured.post(`/manager/payments/new`, this.payment)
        .then(response => {
          this.paymentSuccessful(response)
          this.payments.push(this.payment)
        })
        .catch(error => {
          this.setError(error, 'not payed!')
        })
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createSuccessful (response) {
      this.notice = 'Student Added'
      this.error = ''
    },
    updateSuccessful (response) {
      this.notice = 'Enrollment successfully updated'
      this.error = ''
    },
    paymentSuccessful (response) {
      this.notice = 'Оплата прошла успешно'
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
