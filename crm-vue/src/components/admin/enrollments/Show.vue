<template>
<div class="col-10 mx-auto">
  <b-alert v-if="error" show dismissible ariant="alert">
    {{ error }}
  </b-alert>
  <b-alert v-if="notice" show dismissible ariant="success">
    {{ notice }}
  </b-alert>
  <b-card header="Зачисления">
  <div class="row">
    <div class="col-md-12">
      <h4>{{enrolled_user.name}}</h4>
    </div>
      <div class="col-6">
        <table>
        <tr>
            <td>Группа:</td>
            <td v-show="enrollment !== editedEnrollment" @dblclick="editEnrollment(enrollment)" class="userInfo">
              <router-link :to="`/admin/groups/${groups[enrollment.group_id].slug}`">{{ groups[enrollment.group_id].title }}</router-link></td>
              <td v-show="enrollment === editedEnrollment">
                <select class="form-control" v-model="group.title"  @keyup.enter="update(editedEnrollment)">
                <option v-for="group in groups_next" v-bind:value="group.id" v-bind:key="group.id">
                {{ group.title }}
              </option> 
              </select></td>
          </tr>
        <tr>
            <td>Ожидаемая сумма:</td>
            <td v-show="enrollment !== editedEnrollmentExpected" @dblclick="editEnrollmentExpected(enrollment)" class="userInfo">
              {{ enrollment.expected_value }}</td>
              <td v-show="enrollment === editedEnrollmentExpected"
                v-on:blur="enrollment.editedEnrollment=false; $emit('update')">
              <input class="form-control" v-if="enrollment === editedEnrollmentExpected" v-click-outside="check" v-request-focus v-model="enrollment.expected_value" @keyup.enter="update(editedEnrollment)"/></td>
          </tr>
            <tr>
            <td>Статус</td>
            <td v-show = "enrollment !== editedEnrollmentStatus"  @dblclick="editEnrollmentStatus(enrollment)" class="userInfo">
              <span v-if="enrollment.status==='enrolled'" class="enrolled">Зачислено</span>
              <span v-if="enrollment.status==='dropped'" class="dropped">Сбросано</span>
              <span v-if="enrollment.status==='skipped'" class="skipped">Пропущено</span></td>
              <td v-show = "enrollment === editedEnrollmentStatus" v-on:blur="enrollment.editedEnrollment=false; $emit('update')">
              <select class="form-control" v-if="enrollment === editedEnrollmentStatus" v-click-outside="checkStatus" v-model="enrollment.status"  @keyup.enter="update(editedEnrollment)">
                <option value='skipped'>пропущено</option>
                <option value='dropped'>сбросано</option>
                <option value='enrolled'>зачислено</option>
              </select>
            </td>
          </tr>
        </table>
        <button type="submit" class="btn btn-primary mb-3" @click="checkName(group)">Обновить</button>
      <!--сумма оплаты ... не понятно как тут поместить так как hidden стоит-->
      <form class="form-app form-edit form-inline" @submit.prevent="pay">
        <div class="form-group">
          <input type='hidden' :model="payment.enrollment_id = this.$route.params.id">
        </div>
        <div class="form-group">
          <input type='hidden' :model="payment.course_id = this.course_id">
        </div>
        <div class="form-group">
          <input type='hidden' :model="payment.receiver_id = this.$store.getters.currentUserId">
        </div>
        <div class="form-group">
          Сумма оплаты: <input class="form-control w-50 ml-3" placeholder="" type='number' v-model="payment.sum">
        </div>
        <button v-if="payment.sum > 0" type="submit" class="btn btn btn-sm btn-success btn-secondary">Pay</button>
        <button v-if="payment.sum < 0" type="submit" class="btn btn btn-sm btn-danger btn-secondary">Возварт</button>
      </form>
</div>
    <div class="col-md-5">
        <h6> Оплачено: {{Number(paid)+Number(payment.sum)}}</h6>
        <h6> К оплате: {{left-payment.sum}}</h6>
        <h6 v-if="paid_days < 0"><button class="btn btn-sm btn-warning" name="button">До след. оплаты: {{paid_days}} дней</button></h6>
        <h6 v-else>До след. оплаты: {{paid_days}} дней</h6>
        <table class="table">
          <thead>
            <tr>
              <th>Сумма</th>
              <th>Получатель</th>
              <th>Дата</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="payment in payments" :key="payment.id">
              <td> {{ payment.sum }} </td>
              <td>{{ users[payment.receiver_id].name }}</td>
              <td>{{payment.created_at | formatDate}}</td>
            </tr>
          </tbody>
        </table>
    </div>
  </div>
<div>
  <!-- <button onclick="goBack()">Go Back</button> -->
  <input class="btn btn-link" type="button" value="Назад" onClick="history.back()">
</div>
</b-card>
</div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
export default {
  name: 'EnrollmentNew',
  data() {
    return {
      error: '',
      notice: '',
      enrolled_user: '',
      enrollment: {
        user_id: '',
        group_id: '',
        status: '',
        created_at: '',
        expected_value: ''
      },
      payments: [],
      errorClass: '',
      isActive: false,
      payment: {
        sum: '',
        enrollment_id: '',
        receiver_id: '',
        created_at: '',
        course_id: ''
      },
      course_id: '',
      users: [],
      groups: [],
      group: {
        title: ''
      },
      paid: '',
      left: '',
      paid_days: '',
      editedEnrollment: '',
      editedEnrollmentExpected: '',
      editedEnrollmentStatus: '',
      enrollment1: '',
      groups_next: []
    }
  },
  created() {
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
    this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/enrollments/${this.$route.params.id}`)
      .then(response => {
        this.enrollment = response.data.enrollment
        this.payments = response.data.payments
        this.paid = response.data.paid
        this.left = response.data.left
        this.paid_days = response.data.paid_days
        this.course_id = response.data.course_id
        this.enrolled_user = response.data.enrolled_user
        this.users = response.data.receivers.reduce((acc, value) => {
          acc[value.id] = value
          return acc
        }, {})
      })
      .catch(error => {
        this.setError(error, 'Пожалуйста, проверьте поля!')
      })
    this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/groups`)
      .then(response => {
        this.groups = response.data.groups.reduce((acc, value) => {
          acc[value.id] = value
          return acc
        }, {})
      })
    this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/courses`)
      .then(response => {
        this.groups_next = response.data.groups
      })
  },
  methods: {
    check () {
      if (this.enrollment1.expected_value !== this.editedEnrollmentExpected.expected_value) {
        this.update()
      }
      else {
        this.editedEnrollmentExpected = ''
      }
    },
    checkStatus () {
      if (this.enrollment1.status !== this.editedEnrollmentStatus.status) {
        this.update()
      }
      else {
        this.editedEnrollmentStatus = ''
      }
    },
    addEnrollment() {
      this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/enrollments/new`, this.enrollment)
        .then(response => {
          this.createSuccessful(response)
        })
        .catch(error => {
          this.setError(error, 'Пожалуйста, проверьте поля!')
        })
    },
    checkName(group) {
      if(this.editedEnrollment.title = group.title) {
        this.enrollment.group_id = group.title
        this.update(group)
      } else {
        this.update(group)
      }
    },
    update(group) {     
      this.editedEnrollment = ''
      this.editedEnrollmentStatus = ''
      this.editedEnrollmentExpected = ''
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/enrollments/${this.$route.params.id}`, this.enrollment)
        .then(response => {
          this.updateSuccessful(response)
        })
        .catch(error => {
          this.setError(error, 'Пожалуйста, проверьте поля!')
        })
    },
    goBack() {
      window.history.back()
    },
    pay() {
      this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/payments/new`, this.payment)
        .then(response => {
          this.paymentSuccessful(response)
          this.payments.push(this.payment)
        })
        .catch(error => {
          this.setError(error, 'not payed!')
        })
    },
    setError(error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createSuccessful(response) {
      this.notice = 'Ученик добавлен'
      this.error = ''
    },
    updateSuccessful(response) {
      this.notice = 'Зачисления успешно обновлены'
      this.error = ''
    },
    paymentSuccessful(response) {
      this.notice = 'Оплата прошла успешно'
      this.error = ''
    },
    createFailed(error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    checkSignedIn() {
      if (!(this.$store.state.signedIn && this.$store.getters.isAdmin)) {
        this.$router.replace('/')
      }
    },
    editEnrollment(enrollment) {
      this.editedEnrollmentExpected = ''
      this.editedEnrollmentStatus = ''
      this.editedEnrollment = enrollment
    },

    editEnrollmentExpected(enrollment){
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/enrollments/${this.$route.params.id}`)
      .then(response => {
        this.enrollment1 = response.data.enrollment
        this.editedEnrollment = ''
        this.editedEnrollmentStatus = ''
        this.editedEnrollmentExpected = enrollment
      })
    },
    editEnrollmentStatus(enrollment){
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/enrollments/${this.$route.params.id}`)
      .then(response => {
        this.enrollment1 = response.data.enrollment
        this.editedEnrollment = ''
        this.editedEnrollmentExpected = ''
        this.editedEnrollmentStatus = enrollment
      })
    },
    updateEnrollment(enrollment){
      this.editedEnrollmentGroup = ''
      this.editedEnrollmentExpected = ''
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$route.params.id}`, {
        user: {
          id: this.enrollment.user_id
        }
      })
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    }
  },
    directives: {
    'enrollment-focus': function (el) {
      el.focus()
    },
    'click-outside': {
        bind: function (el, binding, vNode) {
          // Provided expression must evaluate to a function.
          if (typeof binding.value !== 'function') {
            const compName = vNode.context.name
            let warn = `[Vue-click-outside:] provided expression '${binding.expression}' is not a function, but has to be`
            if (compName) {
              warn += `Found in component '${compName}'`
            }

            console.warn(warn)
          }
          // Define Handler and cache it on the element
          const bubble = binding.modifiers.bubble
          const handler = (e) => {
            if (bubble || (!el.contains(e.target) && el !== e.target)) {
              binding.value(e)
            }
          }
          el.__vueClickOutside__ = handler

          // add Event Listeners
          document.addEventListener('click', handler)
        },

        unbind: function (el, binding) {
          // Remove Event Listeners
          document.removeEventListener('click', el.__vueClickOutside__)
          el.__vueClickOutside__ = null

        }
      }
  },
  components: {
    Admin
  }
}
</script>
<style scoped>
.enrolled{
  background-color: #00e699;
  color: white;
  width: 3rem;
}
  .dropped{
  background-color: #e27450;
  color: white;
  width: 3rem;
}
.skipped {
  background-color: #F0E68C;
  color: white;
  width: 3rem;
}
  .activeClass {
    color: red;
  }
  .errorClass {
    color: yellow;
  }
</style>
