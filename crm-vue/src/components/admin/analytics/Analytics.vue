<template>
<div>
  <b-card class="card" header="Аналитика">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
<div class="charts">
    <div class="row">
      <div class="col-md-6 mx-auto">
        <pie-chart :chart-data="sourceChart" :styles="{height: '400px', width: '500px'}"></pie-chart>
      </div>
    </div>
  <div class="row mt-5">
      <div class="col-md-6 mx-auto mt-5">
        <bar-chart :chart-data="statusChart" :styles="{height: '500px', width: '600px'}"></bar-chart>
      </div>
    </div>
    </div>
  </b-card>
  </div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import VuePagination from '@/components/pagination/Pagination.vue';
import Datepicker from 'vuejs-datepicker'
import BarChart from '@/components/chart/BarChart'
import PieChart from '@/components/chart/PieChart'
import { PulseLoader } from 'vue-spinner/dist/vue-spinner.min.js'

export default {
  name: 'Analytics',
  data () {
    return {
      error: '',
      search: '',
      values: [],
      requests: [],
      loading: true,
      pagi: {
        current_page: 1
      },
      courses: '',
      editedRequest: '',
      start: '',
      end: '',
      chartLabels: [],
      statuses: ['Новая', 'Обработана', 'В процессе', 'В группе'],
      sources: ['Поисковик', 'Соц сети', 'Рекомендация', 'Рассылка', 'Биллбоард', 'Другое']
    }
  },
  mounted() {
    this.getRequests()
  },
  computed: {
    filteredRequests () {
      return this.paginate(this.requests).filter((request) => {
        return this.filterRequests(request)
      })
    },
    statusChart () {
      return this.chartData(true)
    },
    sourceChart () {
      return this.chartData(false)

    }
  },
  created () {
    this.$emit('update:layout', Admin)
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
        this.getRequests()
        this.$http.secured.get('/admin/courses/')
        .then(response => {
          this.courses = response.data.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
          .catch(error => { this.setError(error, 'Something went wrong') })
    } else {
      this.$router.replace('/')
    }
    this.$root.$on('refreshRequests', (message) => {
      console.log(message)
      this.requests.unshift(message)
    })
  },
  methods: {
    getRequests () {
      if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/admin/requests?page=${this.pagi.current_page}&search=${this.search}`)
        .then(response => {
          this.requests = response.data.requests
          this.pagi = response.data.pagination
          this.loading = false
        })
        .catch(error => {
          this.setError(error, 'Something went wrong')
        })
      }
    },

    filterRequests (request) {
      let range = true
      let isStart = (new Date(request.created_at) >= new Date(this.start))
      let isEnd = (new Date(request.created_at) <= new Date(this.end))
      if (this.start && this.end) {
        range = range && isStart && isEnd
      } else {
        if (this.start) {
          range = range && isStart
        } else if (this.end) {
          range = range && isEnd
        }
      }
      return range && (request.name.toLowerCase().match(this.search) || request.phone.toLowerCase().match(this.search))
    },
    chartData (isStatus) {
      return {
        labels: isStatus ? this.statuses : this.sources,
        datasets: [
          {
            label: 'Count',
            backgroundColor: ["#41B883", "#E46651", "#00D8FF", '#FFD700', '#4B0082'],
            data: isStatus ? this.changeValues(true) : this.changeValues(false)
          }
        ]
      }
    },
    changeValues (isStatus) {
      return (isStatus ? this.statuses.map((label) => {
        return this.compareLabels(true, label)
      }) : this.sources.map((label) => {
        return this.compareLabels(false, label)
      }))
    },
    compareLabels (isStatus, label) {
      return this.requests.filter((request) => {
        return (isStatus ? request.status : request.source) === label && this.filterRequests(request)
      }).length
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    showRequestLink () {
      return this.$store.getters.isAdmin || this.$store.getters.isManager
    },
    removeRequest (request) {
      this.$http.secured.delete(`/admin/requests/${request.id}`)
        .then(response => this.requests.splice(this.requests.indexOf(request), 1))
        .catch(error => this.setError(error, 'Невозможно удалить заявку'))
    },
    editRequest (request) {
      this.editedRequest = request
    },
    updateRequest (request) {
      this.editedRequest = ''
      this.$http.secured.patch(`/admin/requests/${request.id}`, {request: {status: request.status, source: request.source, email: request.email, phone: request.phone, course_id: request.course_id }})
        .catch(error => this.setError(error, 'Невозможно обновить заявку'))
    },
    alertDisplay (request) {
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
          this.$swal('Deleted', 'Вы успешно удалили файл', 'success')
          this.removeRequest(request)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  directives: {
    'request-focus': function (el) {
      el.focus()
    }
  },
  components: {Admin, Datepicker, BarChart,VuePagination,PulseLoader,PieChart}
}
</script>
<style lang="css" scoped>
 .request {
   font-size: 11px;
 }
  .danger {
    background: #f6f6f6;
  }

  .success {
    background: #C3E6CB;
  }

  .warning {
    background: #FFEEBA;
  }
#date{
  width: 18.7rem;
  height: 2.5rem;
}
#requests{
  font-size: 0.9em;
}
#date2{
  width: 18.7rem;
  height: 2.5rem;
}
#date:hover, #date2:hover{
  box-shadow: 2px 1px 18px #007bff;
}
.vdp-datepicker__calendar header .prev:after{
  border-right: 10px solid #007bff;
}
.vdp-datepicker__calendar header .next:after{
  border-left: 10px solid #007bff;
}
.vdp-datepicker__calendar .cell.day-header{
  color: #007bff;
}
.table td {
  padding: .5rem;
  align-items: center;
  border-bottom: 1px solid #dee2e6;
  font-weight: 450;
}
.table th {
  border-top: 0px solid #dee2e6;
  color: grey;
  font-weight: 400;
}

</style>
