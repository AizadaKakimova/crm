<template>
  <div class="users col-md-10">
    <breadcrumb></breadcrumb>
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <h3>Users
      <router-link class="btn btn-sm btn-success" to="/manager/user/new"><i class="far fa-plus-square"></i>
      </router-link>
    </h3>
    <br/>
    <input type="text" v-model="search" placeholder="search users"/>
    <table class="table">
      <thead>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Comment</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="user in filteredUsers" :key="user.id" :user="user">
        <td>{{ user.id }}</td>
        <td>
          <router-link :to="`/manager/users/${user.id}`">
            {{ user.name }}
          </router-link>
        </td>
        <td v-if="showUsersLink(user)">
          {{ user.email }}
        </td>
        <td v-else>
          {{ user.email }}
        </td>
        <td>{{ user.phone }}</td>
        <td>{{ user.comment }}</td>
        <td v-if="showUsersLink(user)">
          <router-link :to="`/manager/users/${user.id}`">
            <i class="far fa-eye"></i>
          </router-link>
          <i v-if="showUsersLink(user)" class="fa fa-trash-alt float-right btn btn-sm btn-danger"
             @click="alertDisplay(user)"></i>
        </td>
      </tr>
      </tbody>
    </table>
    <div class="clearfix btn-group col-md-2 offset-md-5">
      <button type="button" class="btn btn-sm btn-outline-secondary" v-if="page != 1" @click="page--"> назад</button>
      <button type="button" class="btn btn-sm btn-outline-secondary" v-for="pageNumber in pages.slice(page-1, page+5)" :key="pageNumber"
              @click="page = pageNumber">{{pageNumber}}
      </button>
      <button type="button" @click="page++" v-if="page < pages.length" class="btn btn-sm btn-outline-secondary">
        вперед
      </button>
    </div>
    <form class="form-app form-edit" @submit.prevent="showStats">
      <div class="form-group">
        start:
        <datepicker v-model="start" name="start"></datepicker>
      </div>
      <div class="form-group">
        end:
        <datepicker v-model="end" name="end"></datepicker>
      </div>
    </form>
    <div> Users: {{ filteredUsers.length }}</div>
  </div>
</template>
<script>

import Manager from '@/components/layouts/manager/Manager'
import Breadcrumb from '@/components/Breadcrumbs'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'UsersList',
  data () {
    return {
      error: '',
      notice: '',
      search: '',
      page: 1,
      perPage: 10,
      pages: [],
      users: [],
      start: '',
      end: '',
      user: {
        phone: '',
        name: '',
        email: ''
      }
    }
  },
  computed: {
    filteredUsers () {
      return this.paginate(this.users).filter((user) => {
        return this.filterUsersByDate(user) && (user.email.toLowerCase().match(this.search) || user.name.toLowerCase().match(this.search) || user.phone.toLowerCase().match(this.search))
      })
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    this.getUsers()
  },
  watch: {
    users () {
      this.setPages()
    }
  },
  methods: {
    showStats () {
    },
    getUsers () {
      if (this.$store.state.signedIn && (this.$store.getters.isAdmin || this.$store.getters.isManager)) {
        this.$http.secured.get('/manager/users')
          .then(response => {
            this.users = response.data
            console.log(response.data)
          })
          .catch(error => {
            this.setError(error, 'Something went wrong')
          })
      } else {
        this.$router.replace('/')
      }
      console.log(this.users)
    },

    setPages () {
      let numberOfPages = Math.ceil(this.users.length / this.perPage)
      for (let index = 1; index <= numberOfPages; index++) {
        this.pages.push(index)
      }
    },

    paginate (users) {
      let page = this.page
      let perPage = this.perPage
      let from = (page * perPage) - perPage
      let to = (page * perPage)
      return users.slice(from, to)
    },

    filterUsersByDate (user) {
      let range = true
      let isStart = (new Date(user.created_at) >= new Date(this.start))
      let isEnd = (new Date(user.created_at) <= new Date(this.end))
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
    showUsersLink (user) {
      return this.$store.getters.isManager && this.$store.getters.currentUserId !== user.id
    },
    /* removeUser (user) {
      this.$http.secured.delete(`/admin/users/${user.id}`)
        .then(response => this.users.splice(this.users.indexOf(user), 1))
        .catch(error => this.setError(error, 'Cannot delete user'))
      this.notice = 'Successfully deleted ' + user.name
    }, */
    alertDisplay (user) {
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
          this.$swal('Deleted', 'You successfully deleted this user', 'success')
          this.removeUser(user)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  components: {Manager, Datepicker, Breadcrumb}
}
</script>
