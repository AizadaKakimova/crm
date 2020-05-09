<template>
  <div class="instructors col-md-6">
    <breadcrumb></breadcrumb>
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <h3>Instructors</h3>
    <input type="text" v-model="search" placeholder="search instructors"/>
    <table class="table table-striped table-hover">
      <thead>
      <tr>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Groups</th>
        <th>Hours this month</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="user in filtederUsers" :key="user.id" :user="user">
        <td>
          <router-link :to="`/manager/instructors/${user.id}`">
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
        <td>{{ group_ids[user.id]}}</td>
        <td>{{teaching_hours[user.id]}}</td>
        <td v-if="showUsersLink(user)">
          <router-link :to="`/manager/instructors/${user.id}`">
            <i class="far fa-eye"></i>
          </router-link>
          <i v-if="showUsersLink(user)" class="fa fa-trash-alt float-right btn btn-sm btn-danger"
             @click="alertDisplay(user)"></i>
        </td>
      </tr>
      </tbody>
    </table>
    <router-link :to="{ path: '/manager/salaries' }">Salaries</router-link>
  </div>
</template>
<script>
import Manager from '@/components/layouts/manager/Manager'
import Breadcrumb from '@/components/Breadcrumbs'

export default {
  name: 'InstructorsListManager',
  data () {
    return {
      error: '',
      notice: '',
      search: '',
      group_ids: '',
      teaching_hours: '',
      users: [],
      start: '',
      end: '',
      salaries: '',
      user: {
        phone: '',
        name: '',
        email: ''
      }
    }
  },
  computed: {
    filtederUsers () {
      return this.users.filter((user) => {
        return user.email.toLowerCase().match(this.search) || user.name.toLowerCase().match(this.search) || user.phone.toLowerCase().match(this.search)
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
        this.$http.secured.get('/manager/instructors')
          .then(response => {
            this.users = response.data.instructors
            this.group_ids = response.data.group_ids
            this.teaching_hours = response.data.teaching_hours
            this.salaries = response.data.salaries
          })
          .catch(error => {
            this.setError(error, 'Something went wrong')
          })
      } else {
        this.$router.replace('/')
      }
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
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    showUsersLink (user) {
      return this.$store.getters.isManager && this.$store.getters.currentUserId !== user.id
    },
    removeUser (user) {
      this.$http.secured.delete(`/manager/instructors/${user.id}`)
        .then(response => this.users.splice(this.users.indexOf(user), 1))
        .catch(error => this.setError(error, 'Cannot delete user'))
      this.notice = 'Successfully deleted ' + user.name
    },
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
  components: {Manager, Breadcrumb}
}
</script>
