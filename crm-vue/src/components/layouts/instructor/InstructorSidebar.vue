<template>
  <div class="sidebar">
    <ul id="navigation" class="list-group list-group-flush">
      <router-link to="/instructor/dashboard" active-class="active" tag="li" class="list-group-item list-group-item-action" id="white">
        <font-awesome-icon icon="coffee"  style="width: 1.8rem"/>  Преподаватель
      </router-link>
      <router-link tag="li" active-class="active" :to="`/instructor/${user.id}/groups`" class="list-group-item list-group-item-action" id="white">
        <font-awesome-icon icon="user-plus" style="width: 1.8rem"/> Группы
      </router-link>
      <router-link tag="li" active-class="active" :to="`/instructor/hours/${user.id}`" class="list-group-item list-group-item-action" id="white">
        <font-awesome-icon icon="user-plus" style="width: 1.8rem"/> Часы
      </router-link>
    </ul>
  </div>
</template>
<script>
export default {
  name: 'Sidebar',
  data () {
    return {
      error: '',
      notice: '',
      groups: '',
      users: [],
      user: {
        phone: '',
        name: '',
        email: ''
      }
    }
  },
  created () {
    this.checkSignedIn()
    this.getGroup()
    this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$store.state.currentUser.id}`)
                .then(response => {
                  this.user = response.data.user
                })
  },
  methods: {
    getGroup () {
      if (this.$store.state.signedIn && this.$store.getters.isInstructor) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/instructor/groups?instructor_id=${this.$store.getters.currentUserId}`)
          .then(response => {
            this.groups = response.data.groups
          })
          .catch(error => { this.setError(error, 'Something went wrong') })
      }
    },
    checkSignedIn () {
      if (this.$store.state.signedIn && this.$store.getters.isInstructor) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/instructor/dashboard`)
          .then(response => {
            if (this.$store.getters.currentUserId === response.data.id) {
              this.$router.replace('/')
              return
            }
            this.request = response.data
          })
          .catch(error => { this.setError(error, 'Something went wrong') })
      } else {
        this.$router.replace('/')
      }
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
      this.notice = ''
    }
  }
}
</script>
<style lang="css" scoped>
.dropdown-menu {
  transform: translate(0px, 36px) !important;
}
.sidebar {
  padding-top: 10%;
  background-color: #fff;
  margin-top: 20%;
  box-shadow: 1px 1px rgba(0,0,0,.125);
}
 #navigation li {
  color: #6c757d;
  background-color: #fff;
  border: white;
  font-size: 0.8rem;
  line-height: 2rem;
}
#white{
  color: white;
}
.active {
  color:black !important;
  text-decoration: none;
  background-color: white !important;
  font-weight: bold;
}
#white:hover {
  color:black;
  text-decoration: none;
}
.sidebar a:hover {
  text-decoration: none;
}
.sidebar ul {
   list-style-type:none;
   margin: 0;
   padding: 0

}
.sidemargin{
  padding-right: 7px;
}
.sidebar ul li{
  padding-left: 10;
}
#navigation li:hover{
   background-color: white;
   text: black;
}
</style>
