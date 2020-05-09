<template>
  <nav class="navbar rounded">
    <ul class="navbar">
      <img src="../../../assets/images/logo.png" alt="" width="150px">
      <li class="nav-item home">
        <router-link class="nav-link" to="/">Home</router-link>
      </li>
    </ul>
    <ul class="navbar ml-auto">
      <li class="nav-item" v-if="showManagerLink()">
        <router-link class="nav-link" to="/manager/dashboard">Manager</router-link>
      </li>
      <li class="nav-item" v-if="showManagerLink()">
        <b-dropdown id="notificationsDropdown" :text="`Notifications (${notifications.length})`" class="m-md-6">
          <b-dropdown-item href="#" v-for="notification in notifications" :key="notification.id"><router-link :to="`/admin/requests/${JSON.parse(notification.message).id}`">Request from {{ JSON.parse(notification.message).name }}</router-link></b-dropdown-item>
        </b-dropdown>
      </li>
      <li class="nav-item sign-out">
        <router-link :to="`/manager/users/profile/${this.$store.getters.currentUserId}`">
          Profile
        </router-link>
      </li>
      <li class="nav-item sign-out">
        <a class="nav-link" @click="signOut">Sign out</a>
      </li>
    </ul>
  </nav>
</template>
<script>
import ActionCable from 'actioncable'
let cable = ActionCable.createConsumer(
  'ws://localhost:3000/cable'
)

export default {
  name: 'AdminHeader',
  data () {
    return {
      notifications: []
    }
  },
  created () {
    if (this.$store.state.signedIn && (this.$store.getters.isAdmin || this.$store.getters.isManager)) {
      this.getNotifications()
      this.connect()
    } else {
      this.$router.replace('/')
    }
    this.$root.$on('refreshNotifications', (message) => {
      this.$root.$emit('refreshRequests', JSON.parse(message.message))
      this.notifications.unshift(message)
      console.log(message)
    })
  },
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
      this.$http.secured.delete('/signin')
        .then(response => {
          this.$store.commit('unsetCurrentUser')
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Cannot sign out'))
    },
    showManagerLink () {
      return (this.$store.getters.isManager)
    }
  }
}
</script>

<style lang="css" scoped>
  .navbar {
    padding-right: 0;
    padding-left: 0;
  }
  .navbar a {
    cursor: pointer;
    color: #212529;
  }
  .navbar ul {
    list-style: none;
  }
  .navbar .sign-out {
    padding-right: 0;
  }
  .navbar .home {
    padding-left: 0;
  }
</style>
