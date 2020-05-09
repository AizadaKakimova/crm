<template>
  <div class="col-md-12">
  <b-container>
    <b-card class="card" header="Преподаватель">
    <b-row>
    <b-col class="col-md-6">
      <b-alert  v-if="error" show dismissible ariant="alert">
        {{ error }}
      </b-alert>
      <b-alert  v-if="notice" v-model="showDismissibleAlert" dismissible variant="success">
        {{ notice }}
      </b-alert>
              <table>
          <tr>
            <td>Имя:</td>
            <td v-show="user !== editedUser" @dblclick="editUser(user)" class="userInfo">
              {{ user.name }}</td>
              <td v-show="user === editedUser"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input class="form-control" v-if="user === editedUser" v-click-outside="checkUser" v-request-focus v-model="user.name" @keyup.enter = "checkUser()"/></td>
          </tr>
           <tr>
            <td>Почта:</td>
            <td v-show="user !== editedUserEmail" @dblclick="editUserEmail(user)" class="userInfo">
              {{ user.email }}</td>
              <td v-show="user === editedUserEmail"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input class="form-control" v-if="user === editedUserEmail" v-click-outside="checkEmail" v-request-focus v-model="user.email" @keyup.enter = "checkEmail()"/></td>
          </tr>
           <tr>
            <td>Телефон:</td>
            <td v-show="user !== editedUserPhone" @dblclick="editUserPhone(user)" class="userInfo">
              {{ user.phone }}</td>
              <td v-show="user === editedUserPhone"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input class="form-control" v-if="user === editedUserPhone" v-click-outside="checkPhone" v-request-focus v-model="user.image_link" @keyup.enter = "checkPhone()"/></td>
          </tr>
          <tr>
            <td>Фото:</td>
            <td v-show="user !== editedUserImage" @dblclick="editUserImage(user)" class="userInfo">
              {{ image_link }}</td>
              <td v-show="user === editedUserImage"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input class="form-control" v-if="user === editedUserImage" v-click-outside="checkImage" v-request-focus v-model="user.image_link" @keyup.enter = "checkImage()"/></td>
          </tr>
        </table>
<div class="row mt-3">
  <ul>
    <li id="enrolled">Зачислено</li>
    <li id="dropped">Сбросано</li>
  </ul>
</div>
    </b-col>
    <b-col class="col-md-6">
    <h4>Часы в этом месяце: {{ teaching_hours }}</h4>
    <div v-if="salary">
      <span class="btn btn-success" v-if="salary">Salary this month: {{ (teaching_hours*salary.hourly) + salary.monthly }}</span>
      <router-link :to="`/admin/instructors/${this.user.id}/salaries/${this.salary.id}`" class="btn btn-md btn-warning">Изменить зарплату</router-link>
    </div>
    <router-link v-else :to="`/admin/instructors/salaries/${this.user.id}`" class="btn btn-md btn-primary">Добавить зарплату</router-link>
    <div v-if="groups.length" class="groups">
      <h4>Groups</h4>
        <div class="tabs">
          <div class="d-flex justify-content-end">
            <button class="btn btn-outline-primary mb-3" v-for="(tab, index) in tabs" :class="{active : currentTab === index}" @click="currentTab = index">{{ tab }}</button>
          </div>
      </div>
<div class="tab-content">
  <div v-show="currentTab === 0">
    <div v-if="groups.length && new Date(group.start) < new Date() &&
            new Date(group.end) > new Date()" v-for="group in filteredGroups" :key="group.id"
              :group="group">
    <div class="row">
    <div class="col-6">
        <h5><router-link :to="`/admin/groups/${group.slug}`">
          {{ group.title }}
        </router-link></h5>from: {{ group.start | formatDate }} to {{ group.end | formatDate }}
  </div>
  <div class="col-5">
    <table class="table">
      <tr>
        <td class="enrolled">{{enrollments[group.id].enrolled}}</td>
        <td class="dropped">{{enrollments[group.id].dropped}}</td>
      </tr>
    </table>
  </div></div>
        </div>
  </div>
</div>
<div class="tab-content">
  <div v-show="currentTab === 1">
    <div v-if="groups.length && new Date(group.start) < new Date() &&
            new Date(group.end) < new Date()" v-for="group in filteredGroups" :key="group.id"
              :group="group">
    <div class="row">
      <div class="col-6">
        <h5><router-link :to="`/admin/groups/${group.slug}`">
          {{ group.title }}
        </router-link></h5> от {{ group.start | formatDate }} до {{ group.end | formatDate }}
        </div>
    <div class="col-5">
      <table class="table">
        <tr>
          <td class="enrolled">{{enrollments[group.id].enrolled}}</td>
          <td class="dropped">{{enrollments[group.id].dropped}}</td>
        </tr>
      </table>
    </div>
  </div>
</div>
</div>
</div>
<div class="tab-content">
  <div v-show="currentTab === 2">
    <div v-if="groups.length && new Date(group.start) > new Date()" v-for="group in filteredGroups" :key="group.id"
              :group="group">
    <div class="row">
      <div class="col-6">
        <h5><router-link :to="`/admin/groups/${group.slug}`">
          {{ group.title }}
        </router-link></h5>from: {{ group.start | formatDate }} to {{ group.end | formatDate }}
    </div>
    <div class="col-5">
      <table class="table">
        <tr>
          <td class="enrolled">{{enrollments[group.id].enrolled}}</td>
          <td class="dropped">{{enrollments[group.id].dropped}}</td>
        </tr>
      </table>
    </div>
        </div>
  </div>
</div>
</div>
</div>
    <div v-else>
      <h3>No groups</h3>
    </div>
  </b-col>
</b-row>
</b-card>
</b-container>
</div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import Breadcrumb from '@/components/Breadcrumbs'
export default {
  name: 'InstructorsShow',
  data () {
    return {
      error: '',
      notice: '',
      enrollments: {},
      groups: [],
      teaching_hours: '',
      requests: '',
      salary: null,
      currentTab: 0,
      startDate: '',
      endDate: '',
      tabs: ['Активные', 'Прошлые', 'Запланированные'],
      user: {
        name: '',
        role: '',
        phone: '',
        email: '',
        birthdate: '',
        school: '',
        image_link: ''
      },
      editedUser: '',
      editedUserPhone: '',
      editedUserEmail: '',
      editedUserImage: '',
      show: false,
      search: '',
      courseList: '',
      page: 1,
      perPage: 10,
      pages: [],
      users: {},
      instructor: {
        name: ''
      },
      course: {
        title: ''
      },
      group: {
        title: '',
        course_id: '',
        instructor_id: '',
        start: '',
        end: ''
      },
      courses: [],
      editedGroup: '',
      showDismissibleAlert: false
    }
    },
  watch: {
    '$route' () {
      this.breadcrumbList = this.$route.meta.breadcrumb
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
    this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/instructors/${this.$route.params.id}`)
      .then(response => {
        this.user = response.data.instructor
        this.groups = response.data.groups
        this.salary = response.data.salary
        this.enrollments = response.data.enrollments
        this.teaching_hours = response.data.teaching_hours
        this.image_link = response.data.image_link
      })
      .catch(error => this.updateFailed(error))
  },
  methods: {
    updateSuccessful (response) {
      this.notice = 'Преподаватель обновлен'
      this.error = ''
    },
    updateFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
      this.notice = ''
    },
    checkSignedIn () {
      if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$route.params.id}`)
          .then(response => {
            this.user = response.data.user
          })
          .catch(error => { this.setError(error, 'Что-то пошло не так') })
      } else {
        this.$router.replace('/')
      }
    },
    checkUser () {
      if (this.user1.name !== this.editedUser.name) {
        this.updateUser()
      } else {
        this.editedUser = ''
      }
    },
    checkEmail () {
      if (this.user1.email !== this.editedUserEmail.email) {
        this.updateUser()
      } else {
        this.editedUserEmail = ''
      }
    },
    checkPhone () {
      if (this.user1.phone !== this.editedUserPhone.phone) {
        this.updateUser()
      } else {
        this.editedUserPhone = ''
      }
    },
    checkImage () {
      if (this.user1.image_link !== this.editedUserImage.image_link) {
        this.updateUser()
      } else {
        this.editedUserImage = ''
      }
    },
    editUser (user) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/instructors/${this.$route.params.id}`)
      .then(response => {
        this.user1 = response.data.instructor
        this.editedUserEmail = ''
        this.editedUserPhone = ''
        this.editedUserImage = ''
        this.editedUser = user
      })
    },
    editUserImage (user) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/instructors/${this.$route.params.id}`)
      .then(response => {
        this.user1 = response.data.instructor
        this.editedUserEmail = ''
        this.editedUserPhone = ''
        this.editedUser = ''
        this.editedUserImage = user
      })
    },
    editUserEmail (user) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/instructors/${this.$route.params.id}`)
      .then(response => {
        this.user1 = response.data.instructor
        this.editedUser = ''
        this.editedUserPhone = ''
        this.editedUserImage = ''
        this.editedUserEmail = user
      })
    },
    editUserPhone (user) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/instructors/${this.$route.params.id}`)
      .then(response => {
        this.user1 = response.data.instructor
        this.editedUser = ''
        this.editedUserEmail = ''
        this.editedUserImage = ''
        this.editedUserPhone = user
      })
    },
    paginate (groups) {
      let page = this.page
      let perPage = this.perPage
      let from = (page * perPage) - perPage
      let to = (page * perPage)
      return groups.slice(from, to)
    },
    updateUser (user) {
      this.editedUser = ''
      this.editedUserEmail = ''
      this.editedUserPhone = ''
      this.editedUserImage = ''
      this.showDismissibleAlert = true
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/instructors/${this.$route.params.id}`, {
        user: {
          name: this.user.name,
          email: this.user.email,
          phone: this.user.phone,
          image_link: this.user.image_link
        } 
      })
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
        
    }
  },
  computed: {
    filteredGroups () {
      return this.paginate(this.groups.filter((group) => {
        let range = true
        if (this.startDate) {
          range = range && new Date(group.start) >= new Date(this.startDate)
        }
        if (this.endDate) {
          range = range && new Date(group.end) <= new Date(this.endDate)
        }
        if (this.courseList) {
          range = range && this.courseList === group.course_id
        }
        return range && group.title.toLowerCase().match(this.search)
      }))
    }
  },
  directives: {
    'enrollment-focus': function (el) {
      el.focus()
    },
    'click-outside': {
        bind: function (el, binding, vNode) {
          // Provided expression must evaluate to a function.
          if (typeof binding.value !== 'function') {
            const compName = vNode.context.name
            let warn = `[Vue-click-outside:] provided expression '${binding.expression}' is not a function, but has to be`
            if (compName) {
              warn += `Found in component '${compName}'`
            }

            console.warn(warn)
          }
          // Define Handler and cache it on the element
          const bubble = binding.modifiers.bubble
          const handler = (e) => {
            if (bubble || (!el.contains(e.target) && el !== e.target)) {
              binding.value(e)
            }
          }
          el.__vueClickOutside__ = handler

          // add Event Listeners
          document.addEventListener('click', handler)
        },

        unbind: function (el, binding) {
          // Remove Event Listeners
          document.removeEventListener('click', el.__vueClickOutside__)
          el.__vueClickOutside__ = null

        }
      }
  },
  components: { Admin, Breadcrumb }
}
</script>
<style scoped>
  .enrolled{
  background-color: #00e699;
  color: white;
  width: 3rem;
}
  .dropped{
  background-color: #e27450;
  color: white;
  width: 3rem;
}
#enrolled{
  color: #00e699;
  font-size: 1.1rem;
}
#dropped{
  color: #e27450;
  font-size: 1.1rem;

}
</style>
