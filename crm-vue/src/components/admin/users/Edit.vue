<template>
  <div class="row">
    <div class="col-md-4 col-xs-4">
      <b-alert  v-if="error" show dismissible variant="danger">
        {{ error }}
      </b-alert>
      <b-alert v-model="showDismissibleAlert" dismissible v-if="notice" variant="success">
        {{ notice }}
      </b-alert>
      <b-card header = "Редактирование пользователя" class="card">
        <table>
          <tr>
            <td><font-awesome-icon :icon="['fas', 'users']"  class="mr-3 icon3"/></td>
            <td v-show="user !== editedUser" @dblclick="editUser(user)" class="userInfo">
              <span v-if="user.name===null" class="spanNull" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
              <span v-else>{{ user.name }}</span></td>
              <td v-show="user === editedUser"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input class="form-control" v-if="user === editedUser" v-click-outside="checkUser" v-request-focus v-model="user.name" @keyup.enter="checkUser()"/></td>
          </tr>
           <tr>
            <td><font-awesome-icon :icon="['far', 'envelope-open']"  class="mr-3 icon3"/></td>
            <td v-show="user !== editedUserEmail" @dblclick="editUserEmail(user)" class="userInfo">
              <span v-if="user.email===null" class="spanNull" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
              <span v-else>{{ user.email }}</span></td>
              <td v-show="user === editedUserEmail"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input class="form-control" v-if="user === editedUserEmail" v-click-outside="checkEmail" v-request-focus v-model="user.email" @keyup.enter="checkEmail()"/></td>
          </tr>
           <tr>
            <td><font-awesome-icon :icon="['far', 'comment']"  class="mr-3 icon3"/></td>
            <td v-show="user !== editedUserPhone" @dblclick="editUserPhone(user)" class="userInfo">
              <span v-if="user.phone===null" class="spanNull" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
              <span v-else>{{ user.phone }}</span></td>
              <td v-show="user === editedUserPhone"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input class="form-control" v-if="user === editedUserPhone" v-click-outside="checkPhone" v-request-focus v-model="user.phone" @keyup.enter="checkPhone()" v-mask="'+#-(###)-###-##-##'"/></td>
          </tr>
           <tr>
            <td><font-awesome-icon :icon="['fas', 'calendar-alt']"  class="mr-3 icon3"/></td>
            <td v-show="user !== editedUserDate" @dblclick="editUserDate(user)" class="userInfo">
              <span v-if="user.birthdate===null" class="spanNull" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
              <span v-else>{{ user.birthdate | formatDate }}</span>
            </td>
             <td v-show="user === editedUserDate" v-on:blur="user.editedUser=false; $emit('update')">
            <datepicker v-model="user.birthdate" v-if="user === editedUserDate" @keyup.enter="checkDate()" v-click-outside="checkDate"></datepicker>
            </td>
          </tr>
          <tr>

            <td>
              <font-awesome-icon icon="user-ninja" class="mr-3 icon3"/></td>
            <td v-show="user !== editedUserRole" @dblclick="editUserRole(user)" class="userInfo">
              <span v-if="user.role===null" class="spanNull" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
              <span v-if="user.role==='admin'">Админ</span>
              <span v-if="user.role==='instructor'">Преподавать</span>
              <span v-if="user.role==='user'">Пользователь</span></td>
              <td v-show="user === editedUserRole"
                v-on:blur="user.editedUser=false; $emit('update')">
              <select v-model="user.role" v-request-focus
                      @keyup.enter="checkRole()" id="role" :key="user.role" class="form-control" v-if="user === editedUserRole" v-click-outside="checkRole">
                <option v-for="role in roles" :value="user.role" :key="role">{{ role }}</option>
              </select>
              </td>
          </tr>
        </table>
                <button type="submit" class="btn btn-primary mb-3" @click="updateUser()">Обновить</button>
    </b-card>
  </div>

  <div class="col-md-6">
    <b-card class="card" header="Группы">
<div class="row ml-1 mt-3">
  <div v-if="requests.length" >
        <h4>Заявки</h4>
        <p v-for="request in requests" :key="request.id">
          <router-link :to="`/admin/requests/${request.id}`">
            {{ request.created_at | formatDate }}
          </router-link>
        </p>
      </div>
      <div v-else>
        <h4>Нет заявки</h4>
      </div>
</div>
      <div class="row ml-1 mt-3">
      <div v-if="groups.length" >
        <h4>Группы</h4>
        
        <p v-for="group in groups" :key="group.id" :group="group">
          <router-link :to="`/admin/groups/${group.slug}`">
            {{ group.title }}
          </router-link>
        </p>
      </div>
      <div v-else>
        <h4>Не записан в группу</h4>
      </div>
      <div class="col-md-4">
        <a v-b-toggle="'tgl'" variant="info" class="btn btn-sm btn-primary">
          Добавить в группу
        </a>
           <b-collapse :id="'tgl'">
            Выберите курс: <select v-model="course.title" class="form-control mt-3">
              <option v-for="course in courses">
                {{ course.title }}
              </option> 
            </select>
            <select v-model="group.title" class="form-control mt-3">
              <option v-for="item in next">
                {{item}} 
              </option>
              <p v-model="enrollment.user_id">{{user.id}}</p>
            </select>
            <button type="button" class="btn btn-sm btn-warning mt-3" @click="addEnrollment()" name="button">добавить</button>
            </b-collapse> 
            </div>

</div>
    </b-card>
  </div>
</div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import Breadcrumb from '@/components/Breadcrumbs'
import Datepicker from 'vuejs-datepicker'
export default {
  name: 'UserEdit',
  data () {
    return {
      error: '',
      notice: '',
      groups_next: [],
      users: [],
      enrollments: '',
      course: {
        title: '',
        id: ''
      },
      group: {
        id: '',
        title: ''
      },
      groups: '',
      requests: '',
      editedUser: '',
      editedUserEmail: '',
      editedUserPhone: '',
      editedUserRole: '',
      editedUserDate: '',
      userName: '',
      showDismissibleAlert: true,
      roles: ['админ', 'преподаватель', 'пользователь'],
      enrollment: {
        group_id: '',
        user_id: '',
        status: 'enrolled',
        expected_value: 50000
      },
      show: false,
      to_groups: '',
      courses: [],
      user: {
        name: '',
        phone: '',
        email: '',
        birthdate: '',
        school: ''
      },
      hasFocus: false,
      user1: {
        name: '',
        phone: '',
        email: '',
        birthdate: '',
        school: ''
      },
      showDismissibleAlert: false,
      courses_next: ''
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
    this.getUser()
    this.getNextGroups()
    this.getGroups()
    this.getCourses()
    this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/groups`)
        .then(response => {
          this.courses_next = response.data.courses
        })
  },
  computed: {
    next() {
      let groupsList = []
      for(let j=0;j<this.courses_next.length;j++){
        if(this.courses_next[j].title==this.course.title){
          this.course.id = this.courses_next[j].id
        }
      }
      for (let i=0; i<this.groups_next.length; i++){
          if(this.course.id === this.groups_next[i].course_id) {
            groupsList.push(this.groups_next[i].title)
        }
          
      } 
      return groupsList
    }
  },
  methods: {
    getUser () {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$route.params.id}`)
        .then(response => {
          this.user = response.data.user
          this.$store.commit('setUser', { user: response.data.user })
          this.enrollment.user_id = this.user.id
          this.enrollments = response.data.enrollments
          this.groups = response.data.groups
          this.requests = response.data.requests
        })
        .catch(error => this.updateFailed(error))
    },
    getCourses () {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses`)
        .then(response => {
          this.courses = response.data.courses.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
    },
    getNextGroups () {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}`)
        .then(response => {
          this.groups_next = response.data.groups
        })
    },
    addEnrollment () {
      for(let i=0;i<this.groups_next.length;i++){
        if(this.groups_next[i].title === this.group.title){
          this.enrollment.group_id = this.groups_next[i].id 
          this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/enrollments/new`, this.enrollment)
          .then(response => { this.createSuccessful(response) })
          .catch(error => { this.setError(error, 'Пожалуйста, проверьте поля!') })
      } else  { i++ }
      }
    },
    createSuccessful (response) {
      this.showDismissibleAlert = true
      this.notice = 'Ученик добавлен'
      this.error = ''
    },
    updateSuccessful (response) {
      this.notice = 'Пользователь обновлен'
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
      if (this.user1.name !== this.editedUser.name){
        this.updateUser()
      }
      else {
        this.editedUser = ''
      }
    },
    checkEmail () {
      if (this.user1.email !== this.editedUserEmail.email){
        this.updateUser()
      }
      else {
        this.editedUserEmail = ''
      }
    },
    checkPhone () {
      if (this.user1.phone !== this.editedUserPhone.phone){
        this.updateUser()
      }
      else {
        this.editedUserPhone = ''
      }
    },
    checkDate () {
      if (this.user1.birthdate !== this.editedUserDate.birthdate){
        this.updateUser()
      }
      else {
        this.editedUserDate = ''
      }
    },
    checkRole () {
      if (this.user1.role !== this.editedUserRole.role){
        this.updateUser()
      }
      else {
        this.editedUserRole = ''
      }
    },
    getGroups () {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/groups/`)
        .then(response => {
          this.to_groups = response.data.groups
        })
        .catch(error => this.updateFailed(error))
    },
    // addToGroup () {
    //   this.$http.secured.post(`/admin/enrollments/new`, this.enrollment)
    //     .then(response => {
    //       this.getUser()
    //       this.createSuccessful(response)
    //     })
    //     .catch(error => { this.setError(error, 'Пожалуйста, проверьте поля!') })
    // },
    
    createFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    editUser (user) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$route.params.id}`)
          .then(response => {
            this.user1 = response.data.user
            this.editedUserEmail = ''
            this.editedUserDate = ''
            this.editedUserPhone = ''
            this.editedUserSchool = ''
            this.editedUserRole = ''
            this.editedUser = user
          })
    },
    editUserEmail (user) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$route.params.id}`)
          .then(response => {
            this.user1 = response.data.user
            this.editedUser = ''
            this.editedUserPhone = ''
            this.editedUserDate = ''
            this.editedUserSchool = ''
            this.editedUserRole = ''
            this.editedUserEmail = user
          })
    },
    editUserPhone (user) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$route.params.id}`)
          .then(response => {
            this.user1 = response.data.user
            this.editedUser = ''
            this.editedUserEmail = ''
            this.editedUserDate = ''
            this.editedUserSchool = ''
            this.editedUserRole = ''
            this.editedUserPhone = user
          })
    },

    editUserRole (user) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$route.params.id}`)
          .then(response => {
            this.user1 = response.data.user
            this.editedUser = ''
            this.editedUserEmail = ''
            this.editedUserPhone = ''
            this.editedUserDate = ''
            this.editedUserSchool = ''
            this.editedUserRole = user
          })
    },
    editUserDate (user) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$route.params.id}`)
          .then(response => {
            this.user1 = response.data.user
            this.editedUser = ''
            this.editedUserEmail = ''
            this.editedUserPhone = ''
            this.editedUserSchool = ''
            this.editedUserRole = ''
            this.editedUserDate = user
          })
    },
    updateUser (user) {
      this.editedUser = ''
      this.editedUserEmail = ''
      this.editedUserPhone = ''
      this.editedUserSchool = ''
      this.editedUserRole = ''
      this.editedUserDate = ''
      this.showDismissibleAlert = true
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$route.params.id}`, {
        user: {
          role: this.user.role,
          name: this.user.name,
          email: this.user.email,
          phone: this.user.phone,
          birthdate: this.user.birthdate,
          school: this.user.school
        }
      })
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    }
  },
  props: {
    value: Boolean
  },
    directives: {
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
      },
      'request-focus': function (el) {
        el.focus()
      }
    },
  components: { Admin, Datepicker, Breadcrumb }
}
</script>
<style scoped>
  .userInfo{
    font-size: 1rem;
}
a{
  color: blue;
}
</style>
