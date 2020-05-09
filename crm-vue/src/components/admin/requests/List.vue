<template>
<div>
<div class="row">
<div class="col-xs-12 col-md-12">
  <b-card class="card" header = "Таблица заявок">
    <b-alert class="col-4 alert-danger" v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <form class="form-inline">
      <input type="text" v-model="search" placeholder="Поиск..." aria-label="search" class="form-control mr-sm-2" @keyup="getRequests()" required/>
    </form>
    <div class = "table-responsive table-hover mt-3">
      <div class="btn-group col-md-2" >
      <vue-pagination  :pagination="pagi"
                 @paginate="getRequests()"
                 :offset="4">
      </vue-pagination>
    </div>
      <table class="table first-td-padding" id="requests">
        <thead>
        <tr>
          <th>ID</th>
          <th>Имя</th>
          <th>Телефон</th>
          <th>Почта</th>
          <th>Статус</th>
          <th>Курс</th>
          <th>Филиал</th>
          <th>Время</th>
          <th></th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="request in requests" :key="request.id" v-bind:class="{success:request.status === 'В группе', warning:request.status === 'В процессе',danger:request.status === 'Обработана'}"
            @dblclick="editRequest(request)">
          <td>
            {{ request.id }}
          </td>
          <td>
            <router-link :to="`/admin/requests/${request.id}`">
              {{ request.name }}
            </router-link>
          </td>
          <td>
            <div v-show="request !== editedRequest">
              {{ request.phone }}
            </div>
            <div v-show="request === editedRequest"
                v-on:blur="request.editedRequest=false; $emit('update')">
              <input v-request-focus v-model="request.phone" v-mask="'+# (###) ### ## ##'"/>
            </div>
          </td>
          <td>
            <div v-show="request !== editedRequest">
              {{ request.email }}
            </div>
            <div v-show="request === editedRequest"
                v-on:blur="request.editedRequest=false; $emit('update')">
              <input v-request-focus v-model.lazy="request.email">
            </div>
          </td>
          <td>
            <div v-show="request !== editedRequest">
              {{ request.status }}
            </div>
            <div v-show="request === editedRequest"
                v-on:blur="request.editedRequest=false; $emit('update')">
              <select v-model="request.status" v-request-focus
                      @keyup.enter="updateRequest(request)" id="status" :key="request.status">
                <option v-for="status in statuses" :value="status" :key="status">{{ status }}</option>
              </select>
            </div>
          </td>
          <td>
            <!-- <div v-show="request !== editedRequest" v-if="request.course_id">
              {{ courses[request.course_id].title }}
            </div> -->
            <div v-show="request === editedRequest"
                v-on:blur="request.editedRequest=false; $emit('update')">
                <select v-model="request.course_id" v-request-focus id="course_id" :key="request.course_id">
                  <option v-if="course.visible" v-for="course in courses"  :value="course.id" :key="course.id">
                    {{ course.title }}
                  </option>
                </select>
            </div>
          </td>
          <td> 
              {{ branches[request.branch_id].name}}
          </td>
          <td>{{ request.created_at | formatTime }}</td>
          <td v-if="showRequestLink()">
            <router-link :to="`/admin/requests/${request.id}`" v-show="request !== editedRequest">
              <font-awesome-icon icon="pencil-alt"/>
            </router-link>
                <font-awesome-icon class="red" icon="trash" @click="alertDisplay(request)"  v-show="request !== editedRequest"/>
            <div v-show="request === editedRequest" @click="updateRequest(editedRequest)">
              <button type="button" class="btn btn-sm btn-warning" name="button">Изменить</button>
              </div>
          </td>
        </tr>
        </tbody>
      </table>
    </div>
    
         <form class="form-app form-edit form-inline">
        <div class="form-group">
           <div class="form-inline">
          <datepicker v-model="start" name="start" placeholder="Дата начала" id="date"></datepicker>
        </div>
          <datepicker v-model="end" placeholder="Дата окончания" name="end" id="date2" class="ml-5"></datepicker>
        </div>
      </form>
  </b-card>
  </div>
  </div>
</div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import VuePagination from '@/components/pagination/Pagination.vue'
import Datepicker from 'vuejs-datepicker'
import BarChart from '@/components/chart/BarChart'

export default {
  name: 'RequestsList',
  data () {
    return {
      error: '',
      search: '',
      values: [],
      requests: [],
      pagi: {
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
  mounted () {
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
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/`)
        .then(response => {
          this.courses = response.data.courses.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
        .catch(error => { this.setError(error, 'Что-то пошло не так') })
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
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/requests?page=${this.pagi.current_page}&search=${this.search}`)
          .then(response => {
            this.branches = response.data.branches.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
            this.requests = response.data.requests
            this.pagi = response.data.pagination
          })
          .catch(error => {
            this.setError(error, 'Что-то пошло не так')
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
            backgroundColor: '#f87979',
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
      this.$http.secured.delete(`/${this.$store.getters.getCurrentCity.slug}/admin/requests/${request.id}`)
        .then(response => this.requests.splice(this.requests.indexOf(request), 1))
        .catch(error => this.setError(error, 'Cannot delete request'))
    },
    editRequest (request) {
      this.editedRequest = request
    },
    updateRequest (request) {
      this.editedRequest = ''
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/requests/${request.id}`, {
        request: {
          status: request.status,
          source: request.source,
          email: request.email,
          phone: request.phone,
          course_id: request.course_id
        }
      })
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
          this.$swal('Deleted', 'Вы успешно удалили', 'success')
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
  components: {Admin, Datepicker, BarChart, VuePagination}
}
</script>
<style lang="css" >
 .request {
   font-size: 11px;
 }
  .danger {
    background: #FFDFDC;
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
.vdp-datepicker__calendar header .prev:after{
  border-right: 10px solid #61adff;
}
.vdp-datepicker__calendar header .next:after{
  border-left: 10px solid #61adff;
}
.vdp-datepicker__calendar .cell.day-header{
  color: #61adff;
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
.charts {
  background: white;
  box-shadow: 1px solid grey;
  border-bottom: 1px solid #dee2e6;
}
.warning:hover{
  background-color: #fcffba!important;
}
.danger:hover{
  background-color: #ffebeb!important;
}
.success:hover{
  background-color: #d1ffde!important;
}
</style>
