<template>
  <div class="requests col-md-10">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <h3>Requests</h3>
    <input type="text" v-model="search" placeholder="Search requests..."/>
    <table class="table">
      <thead>
      <tr>
        <th>id</th>
        <th>name</th>
        <th>email</th>
        <th>phone</th>
        <th>status</th>
        <th>source</th>
        <th>time</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="request in filteredRequests" :key="request.id"
          v-bind:class="{success:request.status === 'enrolled', warning:request.status === 'pending',danger:request.status === 'processed'}"
          @dblclick="editRequest(request)">
        <td>
          {{ request.id }}
        </td>
        <td>
          <router-link :to="`/manager/requests/${request.id}`">
            {{ request.name }}
          </router-link>
        </td>
        <td>
          <div v-show="request !== editedRequest">
            {{ request.email }}
          </div>
          <div class="form-control" v-show="request === editedRequest"
               v-on:blur="request.editedRequest=false; $emit('update')">
            <input v-request-focus v-model.lazy="request.email">
          </div>
        </td>
        <td>
          <div v-show="request !== editedRequest">
            {{ request.phone }}
          </div>
          <div class="form-control" v-show="request === editedRequest"
               v-on:blur="request.editedRequest=false; $emit('update')">
            <input v-request-focus v-model="request.phone" v-mask="'+# (###) ### ## ##'">
          </div>

        </td>
        <td>
          <div v-show="request !== editedRequest">
            {{ request.status }}
          </div>
          <div class="form-control" v-show="request === editedRequest"
               v-on:blur="request.editedRequest=false; $emit('update')">
            <select v-model="request.status" v-request-focus
                    @keyup.enter="updateRequest(request)" class="form-control" id="status">
              <option value='new'>new</option>
              <option value='processed'>processed</option>
              <option value='pending'>pending</option>
              <option value='enrolled'>enrolled</option>
            </select>
          </div>
        </td>
        <td>
          <div v-show="request !== editedRequest">
            {{ request.source }}
          </div>
          <div class="form-control" v-show="request === editedRequest"
               v-on:blur="request.editedRequest=false; $emit('update')">
            <select v-model="request.source" v-request-focus class="form-control" id="source">
              <option v-for="source in sources" :value="source" :key="source">{{ source }}</option>
            </select>
          </div>
        </td>
        <td>{{ request.created_at | formatTime }}</td>
        <td v-if="showRequestLink()">
          <router-link :to="`/manager/requests/${request.id}`" v-show="request !== editedRequest">
            <i class="far fa-eye"></i>
          </router-link>
          <div v-show="request === editedRequest" @click="updateRequest(editedRequest)">
            <i class="far fa-edit"></i>
          </div>
        </td>
        <td>
          <i class="fa fa-trash-alt float-right btn btn-sm btn-danger" @click="alertDisplay(request)"></i>
        </td>
      </tr>
      </tbody>
    </table>
    <div class="btn-group col-md-2">
      <button type="button" class="btn btn-sm btn-outline-secondary" v-if="page !== 1" @click="page--"> назад</button>
      <button type="button" class="btn btn-sm btn-outline-secondary"
              v-for="pageNumber in pages.slice(page - 1, page + 5)" :key="pageNumber"
              @click="page = pageNumber"> {{ pageNumber }}
      </button>
      <button type="button" @click="page++" v-if="page < pages.length" class="btn btn-sm btn-outline-secondary"> вперед
      </button>
    </div>
    <form class="mx-4 my-4">
      <div class="form-group">
        start:
        <datepicker v-model="start" name="start"></datepicker>
      </div>
      <div class="form-group">
        end:
        <datepicker v-model="end" name="end"></datepicker>
      </div>
    </form>
    <bar-chart :chart-data="sourceChart" :styles="{height: '250px', width: '300px'}"></bar-chart>
    <bar-chart :chart-data="statusChart" :styles="{height: '250px', width: '300px'}"></bar-chart>
  </div>
</template>
<script>

import Manager from '@/components/layouts/manager/Manager'
import VPaginator from 'vuejs-paginator'
import Datepicker from 'vuejs-datepicker'
import BarChart from '@/components/chart/BarChart'

export default {
  name: 'RequestsListManager',
  data () {
    return {
      error: '',
      search: '',
      page: 1,
      perPage: 10,
      pages: [],
      values: [],
      requests: [],
      editedRequest: '',
      start: '',
      end: '',
      chartLabels: [],
      statuses: ['new', 'processed', 'pending', 'enrolled'],
      sources: ['Поисковик', 'Соц сети', 'Рекомендация', 'Рассылка', 'Биллбоард', 'Другое'],
      resource_url: '/manager/requests'
    }
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
    this.$emit('update:layout', Manager)
    if (this.$store.state.signedIn && this.$store.getters.isManager) {
      this.$http.secured.get('/manager/requests')
        .then(response => {
          this.requests = response.data
        })
        .catch(error => {
          this.setError(error, 'Something went wrong')
        })
    } else {
      this.$router.replace('/')
    }
    this.$root.$on('refreshRequests', (message) => {
      console.log(message)
      this.requests.unshift(message)
    })
  },
  watch: {
    requests () {
      this.setPages()
    }
  },
  methods: {
    updateResource (data) {
      this.requests = data
    },
    setPages () {
      let numberOfPages = Math.ceil(this.requests.length / this.perPage)
      for (let index = 1; index <= numberOfPages; index++) {
        this.pages.push(index)
      }
    },
    paginate (requests) {
      let page = this.page
      let perPage = this.perPage
      let from = (page * perPage) - perPage
      let to = (page * perPage)
      return requests.slice(from, to)
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
      return range && (request.name.toLowerCase().match(this.search) || request.email.toLowerCase().match(this.search) || request.phone.toLowerCase().match(this.search))
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
      this.$http.secured.delete(`/manager/requests/${request.id}`)
        .then(response => this.requests.splice(this.requests.indexOf(request), 1))
        .catch(error => this.setError(error, 'Cannot delete request'))
    },
    editRequest (request) {
      this.editedRequest = request
    },
    updateRequest (request) {
      this.editedRequest = ''
      this.$http.secured.patch(`/manager/requests/${request.id}`, {request: {status: request.status}})
        .catch(error => this.setError(error, 'Cannot update request'))
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
          this.$swal('Deleted', 'You successfully deleted this file', 'success')
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
  components: {Manager, VPaginator, Datepicker, BarChart}
}
</script>
