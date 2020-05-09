<template>
<div class="row">
  <div class="col-md-3">
    <router-link  :to="`/admin/users`">
      <div class="card bg-primary card1">
        <div class="card-body">
          <blockquote class="blockquote my-2 mb-0 text-white">
            <div class="d-flex justify-content-between">
                <span>Пользователи</span>
                <span class="span2"> {{ users }}</span><font-awesome-icon icon="users" class="fa-2x ml-3 "/>
            </div>
          </blockquote>
        </div>
        </div>
    </router-link>
  </div>
  <div class="col-md-3">
    <router-link  :to="`/admin/requests`">
      <div class="card bg-success card1">
        <div class="card-body">
          <blockquote class="blockquote my-2 mb-0 text-white">
            <div class = "d-flex justify-content-between">
                <span>Новые заявки </span>
                <span class="span2">{{ requests }}</span><font-awesome-icon icon="user-plus" class="fa-2x"/>
            </div>
          </blockquote>
        </div>
        </div>
    </router-link>
  </div>
  <div class="col-md-3">
    <router-link  :to="`/admin/instructors`">
      <div class="card bg-warning card1">
        <div class="card-body">
          <blockquote class="blockquote my-2 mb-0 text-white">
            <div class = "d-flex justify-content-between">
              <span>Преподаватели</span>
              <font-awesome-icon icon="chalkboard-teacher" class="fa-2x ml-5"/>
            </div>
          </blockquote>
        </div>
        </div>
    </router-link>
  </div>
  <div class="col-md-3">
    <div class="card bg-danger card1">
      <div class="card-body">
        <blockquote class="blockquote my-2 mb-0 text-white">
          <div class = "d-flex justify-content-between">
            <span>Настройки</span>
            <font-awesome-icon icon="cog" class="fa-2x ml-5"/>
          </div>
        </blockquote>
      </div>
    </div>
  </div>
  <div class="col-md-3 mt-5">
    <router-link  :to="`/admin/analytics`">
    <div class="card bg-secondary card1">
      <div class="card-body">
          <blockquote class="blockquote my-2 mb-0 text-white">
            <div class = "d-flex justify-content-between">
              <span>Аналитика</span>
              <font-awesome-icon icon="chart-bar" class="fa-2x ml-5"/>
            </div>
          </blockquote>
      </div>
  </div>
    </router-link>
  </div>
</div>

</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import Breadcrumb from '@/components/Breadcrumbs'
import store from '@/store.js'
export default {
  name: 'AdminDash',
  data () {
    return {
      error: '',
      notice: '',
      users: '',
      requests: ''
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/dashboard`)
        .then(response => {
          this.users = response.data.users
          this.requests = response.data.requests
        })
        .catch(error => { this.setError(error, 'Что-то пошло не так') })
    }
  },
  methods: {
    checkSignedIn () {
      if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/dashboard`)
          .then(response => {
            if (this.$store.getters.currentUserId === response.data.id) {
              this.$router.replace('/')
              return
            }
            this.request = response.data
          })
          .catch(error => { this.setError(error, 'Что-то пошло не так') })
      } else {
        this.$router.replace('/')
      }
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
      this.notice = ''
    }
  },
  components: { Admin, Breadcrumb }
}
</script>

<style scoped>
.card1{
  border-radius: 0!important;
  box-shadow: 2px 2px grey;
}
span{
  font-size: 1.2rem;
  color: #F8F8FF;
}
.fa-2x{
  filter: opacity(50%);
}
.span2{
  filter: opacity(50%);
}
.card1:hover{
  filter: opacity(0.9);
  box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
}
a:hover{
  text-decoration: none!important;
}
</style>
