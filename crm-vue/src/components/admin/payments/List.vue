<template>
    <div class = "row">
<div class = "col-xs-12 col-md-12">
    <b-card header= "Payments Table" class = "card">
      <div class="col-4 alert alert-danger" v-if="error">{{ error }}</div>
      <div class="d-flex">
      <router-link :to="`/admin/payments/chart`">
        <button type="button" class="btn btn-primary" name="button">Показать чарт</button>
      </router-link>
      <p>&nbsp;</p>
      <div class="input-group justify-content-end">
        <form class="form-inline">
          <input type="text" v-model="search" placeholder="Поиск"  aria-label="Search" class="form-control mr-sm-2" id="input-icon-left" name="input-icon-left" @keyup="doFilter()"required/>
          <button type="submit" class="btn btn-outline-primary my-2 my-sm-0"><font-awesome-icon icon="search"/></button>
        </form>
      </div>
      </div>
        <div class = "table-responsive table-hover mt-3">
        <table class="table first-td-padding table-striped">
        <thead>
          <tr>
          <th>Дата        </th>
          <th>Отправитель </th>
          <th>Сумма       </th>
          <th>Получатель  </th>
          <th>Филиал  </th>
          <th>Коммент</th>
          <th>Действия</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="payment in filteredPayments" :key="payment.id" :payment="payment"  @dblclick="editPayment(payment)">
            <td>  {{payment.created_at | formatDate}}</td>
            <td>
              <router-link :to="`/admin/enrollments/${payment.enrollment_id}`">
                  {{  payment.sender }}
              </router-link>
            </td>
            <td>  {{payment.sum}}         </td>
            <td>  {{ payment.receiver }}  </td>
            <td>  {{ branches[payment.branch_id].name }}  </td>
            <td><div v-show="payment !== editedPayment">{{payment.comment}}</div>
            <div v-show="payment === editedPayment"><input v-model="payment.comment"></div>
            </td>
            <td>
              <font-awesome-icon class="red" v-show="payment !== editedPayment" icon="trash" v-if="showPaymentsLink(payment)" @click="alertDisplay(payment)"/>
              <div v-show="payment === editedPayment" @click="updatePayment(editedPayment)">
                <button type="button" class="btn btn-sm btn-warning" name="button">Изменить</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      </div>
      <div class="clearfix btn-group col-md-2 offset-md-5">
        <button type="button" class="btn btn-sm btn-outline-secondary" v-if="page != 1" @click="page--"> назад </button>
        <button type="button" class="btn btn-sm btn-outline-secondary" v-for="pageNumber in pages.slice(page-1, page+5)" :key="pageNumber" @click="page = pageNumber; ">{{pageNumber}}</button>
        <button type="button" @click="page++" v-if="page < pages.length" class="btn btn-sm btn-outline-secondary"> вперед </button>
      </div>
         <form class="form-app form-edit form-inline" @submit.prevent="showStats">

           <div class ="d-flex">
          <datepicker v-model="start" name="start" placeholder="Дата начала" id="date"></datepicker>
              <div class="form-inline">
          <datepicker v-model="end" placeholder="Дата окончания" name="end" id="date2" class="ml-5"></datepicker>
        </div>
        </div>
      </form>
          </b-card>
    </div>
    </div>
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'
import Breadcrumb from '@/components/Breadcrumbs'
import Datepicker from 'vuejs-datepicker'
export default {
  name: 'PaymentList',
  data () {
    return {
      error: '',
      branches: '',
      page: 1,
      perPage: 10,
      pages: [],
      payments: [],
      payment: {
        created_at: '',
        sender: '',
        receiver: '',
        sum: '',
        comment: ''
      },
      courses: [],
      course: {
        course_title: '',
        sum: ''
      },
      receiver_id: '',
      start: '',
      end: '',
      search: '',
      enrollments: '',
      filteredPays: [],
      editedPayment: ''
    }
  },
  computed: {
    filteredPayments () {
      return this.paginate(this.payments).filter((payment) => {
        let range = true
        let isStart = (new Date(payment.created_at) >= new Date(this.start))
        let isEnd = (new Date(payment.created_at) <= new Date(this.end))
        if (this.start && this.end) {
          range = range && isStart && isEnd
        } else {
          if (this.start) {
            range = range && isStart
          } else if (this.end) {
            range = range && isEnd
          }
        }
        return range && payment.sender.toLowerCase().match(this.search)
      })
    },
    withoutPaginate () {
      return this.payments.filter((payment) => {
        let range = true
        let isStart = (new Date(payment.created_at) >= new Date(this.start))
        let isEnd = (new Date(payment.created_at) <= new Date(this.end))
        if (this.start && this.end) {
          range = range && isStart && isEnd
        } else {
          if (this.start) {
            range = range && isStart
          } else if (this.end) {
            range = range && isEnd
          }
        }
        return range
      })
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/payments`)
        .then(response => {
          this.payments = response.data.payments
          this.courses = response.data.course_name
        })
        .catch(error => { this.setError(error, 'Что-то пошло не так') })
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/branches`)
        .then(response => {
          this.branches = response.data.branches.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
        .catch(error => { this.setError(error, 'Что-то пошло не так') })
    } else {
      this.$router.replace('/')
    }
  },
  watch: {
    payments () {
      this.setPages()
    }
  },
  methods: {
    updatePayment (payment) {
      this.editedPayment = ''
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/payments`, {
        payment: {
          comment: this.payment.comment,
        }
      })
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateSuccessful(response) {
      this.notice = 'Пользователь изменен!'
      this.error = ''
    },
    showPaymentsLink (payment) {
      return this.$store.getters.isAdmin || this.$store.getters.isManager
    },
    alertDisplay (payment) {
      this.$swal({
        title: 'Вы уверены что хотите удалить?',
        type: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Да, удалить!',
        cancelButtonText: 'Нет, оставить!',
        showCloseButton: true,
        showLoaderOnConfirm: true
      }).then((result) => {
        if (result.value) {
          this.$swal('Deleted', 'Вы успешно удалили пользователя', 'success')
          this.removePayment(payment)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    },
  removePayment (payment) {
      this.$http.secured.delete(`/${this.$store.getters.getCurrentCity.slug}/admin/payments`)
        .then(response => this.payments.splice(this.payments.indexOf(payment), 1))
        .catch(error => this.setError(error, 'Невозможно удалить пользователя'))
      this.notice = 'Успешно удален '
    },
    editPayment (payment) {
      this.editedPayment = payment
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    getRightDate (date) {
      date = this.start.substring(0, 10)
    },
    setPages () {
      let numberOfPages = Math.ceil(this.payments.length / this.perPage)
      for (let index = 1; index <= numberOfPages; index++) {
        this.pages.push(index)
      }
    },
    paginate (payments) {
      let page = this.page
      let perPage = this.perPage
      let from = (page * perPage) - perPage
      let to = (page * perPage)
      return payments.slice(from, to)
    },
    overall_sum (filPay) {
      let sum = 0
      for (var i = 0; i < filPay.length; i++) {
        sum = filPay[i].sum + sum
      }
      return sum
    }
  },

  components: {Admin, Datepicker, Breadcrumb}
}
</script>
