<template>
  <div class="instructors">
    <b-alert  v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert  v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <b-card header="Преподаватели">
<form class="form-inline">
        <input type="text" v-model="search" placeholder="Поиск..." aria-label="Search" class="form-control mr-sm-2" @keyup="getUsers()" required/>
      </form>
    <div class="table-responsive table-hover mt-3">
      <table class="table first-td-padding table-striped">
      <thead>
        <tr>
          <th>Имя</th>
          <th>Почта</th>
          <th>Телефон</th>
          <th>Группы</th>
          <th>Часы за месяц</th>
          <th>Фото</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in filtederUsers" :key="user.id" :user="user">
          <td>
            <router-link :to="`/admin/instructors/${user.id}`">
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
          <td>{{user.image_link}}</td>
          <td v-if="showUsersLink(user)">
            <router-link :to="`/admin/instructors/${user.id}`">
              <i class="far fa-eye"></i>
            </router-link>
              <font-awesome-icon icon="trash" v-if="showUsersLink(user)" @click="alertDisplay(user)"/>
          </td>
        </tr>
      </tbody>
    </table>
</div>
    <router-link :to="{ path: '/admin/salaries' }">Зарплаты</router-link>
</b-card>
  </div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import Breadcrumb from '@/components/Breadcrumbs'
export default {
  name: 'InstructorsList',
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
        email: '',
        image_link: ''
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
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/instructors`)
          .then(response => {
            this.users = response.data.instructors
            this.group_ids = response.data.group_ids
            this.teaching_hours = response.data.teaching_hours
            this.salaries = response.data.salaries
            // this.image_link = response.data.image_link
            // alert(this.image_link)
          })
          .catch(error => { this.setError(error, 'Что-то пошло не так') })
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
      return this.$store.getters.isAdmin && this.$store.getters.currentUserId !== user.id
    },
    removeUser (user) {
      this.$http.secured.delete(`/${this.$store.getters.getCurrentCity.slug}/admin/instructors/${user.id}`)
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
          this.$swal('Deleted', 'Вы успешно удалили пользователя', 'success')
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
