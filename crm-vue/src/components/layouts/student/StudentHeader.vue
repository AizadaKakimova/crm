<template>
<header class="w-100 headerWhite">
  <nav class="navbar navbar-expand">
    <div class="d-flex w-100">
      <!-- <router-link to="/"><img class="ml-5 logoM" src="/static/logo.png"/></router-link> -->
      <a class="navbar-brand" href="/"></a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse"
              aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon">icon</span>
      </button>
      <div class="dropdown pt-1">
        <button class="dropdown-toggle ml-3" type="button" id="dropdownMenuButton" data-toggle="dropdown"
                aria-haspopup="true" aria-expanded="false">Алматы
        </button>
        <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
          <a class="dropdown-item" href="#">Алматы</a>
          <a class="dropdown-item" href="#">Астана</a>
        </div>
      </div>
      <div class="collapse navbar-collapse justify-content-end" id="navbarCollapse">
        <ul class="navbar-nav">
          <li class="nav-item" v-if="showAdminLink()">
            <router-link class="nav-link" to="/admin/dashboard">Админ</router-link>
          </li>
          <li class="nav-item" v-if="showManagerLink()">
            <router-link class="nav-link" to="/manager/dashboard">Менеджер</router-link>
          </li>
          <li class="nav-item" v-if="showStudentLink()">
              <router-link class="nav-link" to="/student/dashboard">Студент</router-link>
          </li>
          <li class="nav-item" v-if="showAdminLink()">
            <div class="dropdown pt-1">
            <button class="dropdown-toggle ml-3" type="button" id="notificationsDropdown" data-toggle="dropdown"
                    aria-haspopup="true" aria-expanded="false">Уведомления ({{notifications.length}})
            </button>
            <div class="dropdown-menu" aria-labelledby="notificationsDropdown">
              <a class="dropdown-item" href="#" v-for="notification in notifications" :key="notification.id" :href="`/admin/requests/${JSON.parse(notification.message).id}`">Заявка от {{ JSON.parse(notification.message).name }} {{JSON.parse(notification.message).id}}</a>
            </div>
            </div>
          </li>
          <li class="nav-item">
            <router-link class="nav-link" :to="`/admin/users/profile/${this.$store.getters.currentUserId}`">
              <font-awesome-icon icon="user-ninja" class="icon-header"/>
            </router-link>
          <li class="nav-item">
            <a class="nav-link" @click="signOut">
              <font-awesome-icon icon="sign-out-alt" class="icon-header"/>
            </a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</header>
</template>
<script>
  import ActionCable from 'actioncable'
let cable = ActionCable.createConsumer(
  'ws://localhost:3000/cable'
)
export default {
  name: 'Header',
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    getNotifications () {
      this.$http.secured.get('/admin/notifications')
        .then(response => { this.notifications = response.data })
        .catch(error => { this.setError(error, 'Something went wrong') })
    },
    connect () {
      let awn = this.$awn
      let root = this.$root
      cable.subscriptions.create('NotificationsChannel', {
        connected () {
          console.log('connected')
        },
        disconnected () {
          console.log('disconnected')
        },
        received (message) {
          console.log(message)
          root.$emit('refreshNotifications', JSON.parse(message))
          awn.success('Received')
        },
        rejected (message) {
          console.log('rejected')
        }
      })
    },
    signOut () {
      this.$http.secured.delete(`/${this.$store.getters.getCurrentCity.slug}/signin`)
        .then(response => {
          this.$store.commit('unsetCurrentUser')
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Cannot sign out'))
    },
    showAdminLink () {
      return (this.$store.getters.isAdmin)
    },
    showManagerLink () {
      return (this.$store.getters.isManager)
    },
    showStudentLink () {
      return (this.$store.getters.isStudent)
    }
  }
}
</script>

<style lang="css" scoped>
.headerWhite {
  background-color: #fff;
  border-bottom: 1px solid rgba(0,0,0,.125);
}
.icon-header{
  font-size: 1rem;
}
</style>
