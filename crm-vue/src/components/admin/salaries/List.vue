<template>
  <div class="salaries">
    <b-alert  v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert  v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <b-card class="card" header="Salaries">
<form class="form-inline">
        <input type="text" v-model="search" placeholder="Поиск..." aria-label="Search" class="form-control mr-sm-2" @keyup="getUsers()" required/>
      </form>
    <table class="table table-striped table-hover mt-3">
      <thead>
        <tr>
          <th>Name</th>
          <th>Full time</th>
          <th>Monthly Salary</th>
          <th>Hourly Salary</th>
          <th>Hours this month</th>
          <th>Total payment this month</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in filtederUsers" :key="user.id" :user="user" v-if="salaries[user.id][0]">
          <td>
            <router-link :to="`/admin/instructors/${user.id}`">
              {{ user.name }}
            </router-link>
          </td>
          <td>{{ salaries[user.id][0].full_time }}</td>
          <td>{{salaries[user.id][0].monthly}}</td>
          <td>{{salaries[user.id][0].hourly}}</td>
          <td>{{teaching_hours[user.id]}}</td>
          <td>{{monthly_payment(user.id)}}</td>
          <td >
            <router-link :to="`/admin/instructors/${user.id}`">
              <i class="far fa-eye"></i>
            </router-link>
              <font-awesome-icon class="danger" v-show="user" icon="trash" v-if="showUsersLink(user)" @click="alertDisplay(user)"/>
          </td>
        </tr>
      </tbody>
    </table>
</b-card>
  </div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import Breadcrumb from '@/components/Breadcrumbs'
export default {
  name: 'SalaryList',
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
    this.$emit('update:layout', Admin)
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
        this.$http.secured.get('/admin/instructors')
          .then(response => {
            this.users = response.data.instructors
            this.teaching_hours = response.data.teaching_hours
            this.salaries = response.data.salaries
          })
          .catch(error => { this.setError(error, 'Something went wrong') })
      } else {
        this.$router.replace('/')
      }
    },
    monthly_payment (userId) {
      return this.salaries[userId][0].hourly * this.teaching_hours[userId] + this.salaries[userId][0].monthly
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
      return this.$store.getters.isAdmin && this.$store.getters.currentUserId !== user.id
    },
    removeUser (user) {
      this.$http.secured.delete(`/admin/instructors/${user.id}`)
        .then(response => this.users.splice(this.users.indexOf(user), 1))
        .catch(error => this.setError(error, 'Невозможно удалить пользователя'))
      this.notice = 'Успешно удален ' + user.name
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
          this.$swal('Deleted', 'Вы успешно удалили данного пользователя', 'success')
          this.removeUser(user)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  components: { Admin, Breadcrumb }
}
</script>
<style scoped>
  .danger{
    color: red;
  }
</style>
