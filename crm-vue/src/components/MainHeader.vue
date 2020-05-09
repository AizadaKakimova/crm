<template>
<header v-if="$route['name']=='Home'" class="headerBlack w-100">
  <nav class="navbar navbar-expand">
    <div class="d-flex w-100">
      <router-link to="/"><img class="ml-md-5 logoM" src="/static/logo.png"/></router-link>
      <a class="navbar-brand" href="/"></a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse"
              aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon">icon</span>
      </button>
      <div class="dropdown pt-1">
        <button class="dropdown-toggle ml-md-3" type="button" id="dropdownMenuButton" data-toggle="dropdown"
                  aria-haspopup="true" aria-expanded="false" v-if="!this.$store.getters.isCurrentCity"> Ваш город?
        </button>
        <button class="dropdown-toggle ml-md-3" type="button" id="dropdownMenuButton" data-toggle="dropdown"
                aria-haspopup="true" aria-expanded="false" v-else>{{this.$store.getters.getCurrentCity.name}}
        </button>
        <div class="dropdown-menu" aria-labelledby="dropdownMenuButton" >
          <ul>
          <li class="dropdown-item" v-for="city in cities" :to="`/${city.slug}`"  :key="city.id" @click="setCity(city)">{{ city.name }}</li>
          </ul>
        </div>
      </div>
      <div class="collapse navbar-collapse justify-content-end" id="navbarCollapse">
        <ul class="navbar-nav">
          <div v-if="checkSignedIn()">
            <li class="nav-item">
              <a class="nav-link d-flex flex-column" v-if="showAdminLink()" href="/admin/dashboard">
               Admin
              </a>
              <a class="nav-link d-flex flex-column" v-if="showManagerLink()" href="/manager/dashboard">
                Dashboard
              </a>
              <a class="nav-link d-flex flex-column" v-if="showStudentLink()" href="/student/dashboard">
                My Class
              </a>
              <a class="nav-link d-flex flex-column" v-if="showInstructorLink()" href="/instructor/dashboard">
                My Classroom
              </a>
            </li>
          </div>
          <div v-else>
            <li class="nav-item sign">
              <router-link class="nav-link d-flex flex-column" to="/signin">
              Вход
            </router-link>
            </li>
          </div>
          <li class="nav-item leaveForm" data-toggle="modal" data-target="#exampleModal">
            <span class="nav-link d-flex flex-column">Оставить
              заявку</span>
          </li>
        </ul>
      </div>
      <button type="button" class="btn btn-link navbar-toggle collapsed" data-toggle="modal"
              data-target="#menuModal">
        <font-awesome-icon icon='bars' class='mr-md-5 icon2'/>
      </button>
      <menuModal></menuModal>
    </div>
  </nav>
</header>
<header v-else class="headerWhite w-100">
  <nav class="navbar navbar-expand">
    <div class="d-flex w-100">
      <!-- <router-link to="/"><img class="ml-md-5 logoM" src="/static/logo.png"/></router-link> -->
      <a class="navbar-brand" href="/"></a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse"
              aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon">icon</span>
      </button>
      <div class="dropdown pt-1">
        <button class="dropdown-toggle ml-md-3" type="button" id="dropdownMenuButton" data-toggle="dropdown"
                  aria-haspopup="true" aria-expanded="false" v-if="!this.$store.getters.isCurrentCity"> Ваш город?
        </button>
        <button class="dropdown-toggle ml-md-3" type="button" id="dropdownMenuButton" data-toggle="dropdown"
                aria-haspopup="true" aria-expanded="false" v-else>{{this.$store.getters.getCurrentCity.name}}
        </button>
        <div class="dropdown-menu" aria-labelledby="dropdownMenuButton" >
          <ul>
          <li class="dropdown-item" v-for="city in cities" :to="`/${city.slug}`"  :key="city.id" @click="setCity(city)">{{ city.name }}</li>
          </ul>
        </div>
      </div>
      <div class="collapse navbar-collapse justify-content-end" id="navbarCollapse">
        <ul class="navbar-nav">
          <div v-if="checkSignedIn()">
            <li class="nav-item">
              <a class="nav-link d-flex flex-column" v-if="showAdminLink()" href="/admin/dashboard">
                Admin
              </a>
              <a class="nav-link d-flex flex-column" v-if="showManagerLink()" to="/manager/dashboard">
                Dashboard
              </a>
              <a class="nav-link d-flex flex-column" v-if="showStudentLink()" to="/student/dashboard">
                My Class
              </a>
              <a class="nav-link d-flex flex-column" v-if="showInstructorLink()" to="/instructor/dashboard">
                My Classroom
              </a>
            </li>
          </div>
          <div v-else>
            <li class="nav-item sign">
              <router-link class="nav-link d-flex flex-column" to="/signin">
              Sign in
            </router-link>
            </li>
          </div>
          <li class="nav-item" data-toggle="modal" data-target="#exampleModal">
            <span class="nav-link d-flex flex-column">Оставить
            заявку</span>
          </li>
        </ul>
      </div>
      <button type="button" class="btn btn-link navbar-toggle collapsed" data-toggle="modal"
              data-target="#menuModal">
        <font-awesome-icon icon='bars' class='mr-md-5 icon2'/>
      </button>
      <menuModal></menuModal>
    </div>
  </nav>
</header>

</template>
<script>
import menuModal from '@/components/modal/Modal'
export default {
  name: 'MainHeader',
  data () {
    return {
      cities: [],
    }
  },
  created () {
    this.$http.secured.get('/cities/')
    .then(response => {
      this.cities = response.data.cities
    })
    .catch(error => {
      this.setError(error, 'Что-то пошло не так')
    })
     if (this.$store.getters.isCurrentCity) {
       this.currentCity = this.$store.state.currentCity
     }
  },
  methods: {
    checkSignedIn () {
      if (this.$store.state.signedIn) {
        return true
      } else {
        return false
      }
    },
    setCity (city) {
      this.$store.commit('setCurrentCity', { currentCity: city})
      this.currentCity = this.$store.state.currentCity
      location.reload()
    },
    showStudentLink () {
      return (this.$store.getters.isStudent)
    },
    showAdminLink () {
      return (this.$store.getters.isAdmin)
    },
    showManagerLink () {
      return (this.$store.getters.isManager)
    },
    showInstructorLink () {
      return this.$store.getters.isInstructor
    },
    signOut () {
      this.$http.secured.delete(`/${this.$store.getters.getCurrentCity}/signin`)
        .then(response => {
          this.$store.commit('unsetCurrentUser')
          this.$router.replace(`/${this.$store.getters.getCurrentCity}/`)
        })
        .catch(error => this.setError(error, 'Cannot sign out'))
    },
    showModal () {
      this.isModalVisible = true
    },
    closeModal () {
      this.isModalVisible = false
    },
    modalAlmaty () {
      this.$refs['my-modal'].hide()
      this.$router.push('/almaty')
    },
    modalAstana () {
      this.$refs['my-modal'].hide()
      this.$router.push('/astana')
    }
  },
  components: {menuModal}
}
</script>
