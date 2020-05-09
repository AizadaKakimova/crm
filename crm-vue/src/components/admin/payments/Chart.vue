<template>
    <div class="col-md-10 mx-auto">
      <div class="alert alert-danger" v-if="error">{{ error }}</div>
      <b-card class="card" header="Payments Chart">
        <div class="col-8 mx-auto">
      <GChart v-if="!loading" style="height: 500px;"
        :settings="{packages: ['corechart']}"
        type="PieChart"
        :data="chartData"
        :options="chartOptions"
      />
      <h2 v-else>Error loading chart</h2>
          </div>
      <table class="table">
        <thead>
          <tr>
            <th>Course name </th>
            <th>Сумма       </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="course in courses" :key="course.id" :course="course" >
            <td>  {{course.title}}    </td>
            <td>  {{ for_chart_filtered(course.id) }} </td>
          </tr>
        <tr>
          <td style="font-weight: bold;">Сумма</td>
          <td style="font-weight: bold;">{{total_payment}}</td>
        </tr>
        </tbody>

      </table>
      <div class="clearfix btn-group col-md-2 offset-md-5">
        <button type="button" class="btn btn-sm btn-outline-secondary" v-if="page != 1" @click="page--"> назад </button>
        <button type="button" class="btn btn-sm btn-outline-secondary" v-for="pageNumber in pages.slice(page-1, page+5)" :key="pageNumber" @click="page = pageNumber; ">{{pageNumber}}</button>
        <button type="button" @click="page++" v-if="page < pages.length" class="btn btn-sm btn-outline-secondary"> вперед </button>
      </div>
      <form class="form-app form-edit">
        <div class="form-group">
          start:
          <datepicker v-model="start" name="start"></datepicker>
        </div>
        <div class="form-group">
          end: <datepicker v-model="end" name="end"></datepicker>
        </div>
      </form>
      </b-card>
    </div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import Breadcrumb from '@/components/Breadcrumbs'
import Datepicker from 'vuejs-datepicker'
import { GChart } from 'vue-google-charts'
export default {
  name: 'PaymentChartList',
  data () {
    return {
      error: '',
      page: 1,
      perPage: 10,
      pages: [],
      payments: [],
      payment: {
        created_at: '',
        sender: '',
        receiver: '',
        sum: ''
      },
      courses: [],
      course: {
        course_title: '',
        sum: ''
      },
      chartOptions: {
        chart: {
          title: 'Course incomes'
        }
      },
      total_payment: '',
      receiver_id: '',
      start: '',
      end: '',
      search: '',
      enrollments: '',
      notFil: []
    }
  },
  computed: {
    filteredPayments () {
      return this.paginate(this.payments).filter((payment) => {
        return this.filterPayments(payment)
      })
    },
    chartData () {
      return (this.for_chart_filtered('chart'))
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/payments`)
        .then(response => {
          this.payments = response.data.payments
          this.courses = response.data.course_name
          this.total_payment = response.data.total_payment
          var date = new Date()
          var y = date.getFullYear()
          var m = date.getMonth()
          this.start = new Date(y, m, 1)
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
    filterPayments (payment) {
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
    ForfilterPayments () {
      return this.payments.filter((payment) => {
        return this.filterPayments(payment)
      })
    },
    for_chart_filtered (identifier) {
      var lastdata = [['course_name', 'sum']]
      if (identifier !== 'chart') {
        var sum = 0
        for (var z = 0; z < this.ForfilterPayments().length; z++) {
          if (this.ForfilterPayments()[z].course_id === identifier) {
            sum = sum + this.ForfilterPayments()[z].sum
          }
        }
        return (sum)
      } else {
        for (var k = 0; k < this.courses.length; k++) {
          sum = 0
          for (var i = 0; i < this.ForfilterPayments().length; i++) {
            if (this.ForfilterPayments()[i].course_id === this.courses[k].id) {
              sum = sum + this.ForfilterPayments()[i].sum
            }
          }
          lastdata.push([this.courses[k].title, sum])
        }
        return (lastdata)
      }
    }
  },

  components: {Admin, Datepicker, Breadcrumb, GChart}
}
</script>
