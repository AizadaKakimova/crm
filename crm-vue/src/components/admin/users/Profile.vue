<template>
  <b-container>
    <div class="col-5 mx-auto">
      <b-alert  v-if="error" show dismissible ariant="alert">
        {{ error }}
      </b-alert>
      <b-alert  v-if="notice" show dismissible ariant="success">
        {{ notice }}
      </b-alert>
      <b-card header="Мой профиль">
        <table>
          <tr>
            <td>Имя</td>
            <td v-show="user !== editedUser" @dblclick="editUser(user)" class="userInfo">
              {{ user.name }}</td>
              <td v-show="user === editedUser"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input class="form-control" v-if="user === editedUser" v-click-outside="update" v-request-focus v-model="user.name" @keyup.enter="update" @focusout="focus(false)"/></td>
          </tr>
           <tr>
            <td>Почта</td>
            <td v-show="user !== editedUserEmail" @dblclick="editUserEmail(user)" class="userInfo">
              {{ user.email }}</td>
              <td v-show="user === editedUserEmail"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input class="form-control" v-if="user === editedUserEmail" v-click-outside="update" v-request-focus v-model="user.email" @keyup.enter="update"/></td>
          </tr>
           <tr>
            <td>Телефон</td>
            <td v-show="user !== editedUserPhone" @dblclick="editUserPhone(user)" class="userInfo">
              {{ user.phone }}</td>
              <td v-show="user === editedUserPhone"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input class="form-control" v-if="user === editedUserPhone" v-click-outside="update" v-request-focus v-model="user.phone" @keyup.enter="update" v-mask="'+#-(###)-###-##-##'"/></td>
          </tr>
           <tr>
            <td>Дата рождения</td>
            <td v-show="user !== editedUserDate" @dblclick="editUserDate(user)" class="userInfo">
              {{ user.birthdate | formatDate }}
            </td>
             <td v-show="user === editedUserDate" v-on:blur="user.editedUser=false; $emit('update')">
            <datepicker v-model="user.birthdate" v-if="user === editedUserDate" v-click-outside="update"></datepicker>
            </td>
          </tr>
          <tr>
            <td>Роль</td>
            <td v-show="user !== editedUserRole" @dblclick="editUserRole(user)" class="userInfo">
              {{ user.role }}</td>
              <td v-show="user === editedUserRole"
                v-on:blur="user.editedUser=false; $emit('update')">
              <select v-model="user.role" v-request-focus
                      @keyup.enter="update" id="role" :key="user.role" class="form-control" v-if="user === editedUserRole" v-click-outside="update">
                <option v-for="role in roles" :value="role" :key="role">{{ role }}</option>
              </select>
              </td>
          </tr>
        </table>
                <button type="submit" class="btn btn-primary mb-3" @click="update()">Обновить</button>
        </b-card>
    </div>
    <b-col>
    <div v-if="groups.length">
      <h2>Groups</h2>
      <p v-for="group in groups" :key="group.id">
        <router-link :to="`/admin/groups/${group.slug}`">
          {{ group.title }}
        </router-link>
      </p>
    </div>
    <div v-else>
      <h3>No groups</h3>
    </div>
    <div v-if="requests.length">
      <h2>Requests</h2>
      <p v-for="request in requests" :key="request.id">
        <router-link :to="`/admin/requests/${request.id}`">
          {{ request.created_at | formatDate }}
        </router-link>
      </p>
    </div>
    <div v-else>
      <h3>No requests</h3>
    </div>
  </b-col>
  </b-container>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import Breadcrumb from '@/components/Breadcrumbs'
import Datepicker from 'vuejs-datepicker'
export default {
  name: 'UserProfile',
  data () {
    return {
      error: '',
      notice: '',
      enrollments: '',
      groups: [],
      requests: [],
      editedUser: '',
      editedUserEmail: '',
      editedUserPhone: '',
      editedUserSchool: '',
      editedUserRole: '',
      editedUserDate: '',
      user: {
        name: '',
        phone: '',
        email: '',
        birthdate: '',
        school: ''
      }
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
    this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/profile/${this.$store.getters.currentUserId}`)
      .then(response => {
        this.user = response.data.user
        this.enrollments = response.data.enrollments
        this.groups = response.data.groups
        this.requests = response.data.requests
      })
      .catch(error => { this.setError(error, 'Что-то пошло не так') })
  },
  methods: {
    update () {
      this.editedUser = ''
      this.editedUserEmail = ''
      this.editedUserPhone = ''
      this.editedUserSchool = ''
      this.editedUserRole = ''
      this.editedUserDate = ''
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$store.getters.currentUserId}`,
        { user: {
          role: this.user.role,
          name: this.user.name,
          email: this.user.email,
          phone: this.user.phone,
          birthdate: this.user.birthdate,
          school: this.user.school }
        })
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
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
    editUser (user) {
      this.editedUserEmail = ''
      this.editedUserDate = ''
      this.editedUserPhone = ''
      this.editedUserSchool = ''
      this.editedUserRole = ''
      this.editedUser = user
    },
    editUserEmail (user) {
      this.editedUser = ''
      this.editedUserPhone = ''
      this.editedUserDate = ''
      this.editedUserSchool = ''
      this.editedUserRole = ''
      this.editedUserEmail = user
    },
    editUserPhone (user) {
      this.editedUser = ''
      this.editedUserEmail = ''
      this.editedUserDate = ''
      this.editedUserSchool = ''
      this.editedUserRole = ''
      this.editedUserPhone = user
    },
    editUserSchool (user) {
      this.editedUser = ''
      this.editedUserEmail = ''
      this.editedUserDate = ''
      this.editedUserPhone = ''
      this.editedUserRole = ''
      this.editedUserSchool = user
    },
    editUserRole (user) {
      this.editedUser = ''
      this.editedUserEmail = ''
      this.editedUserPhone = ''
      this.editedUserDate = ''
      this.editedUserSchool = ''
      this.editedUserRole = user
    },
    editUserDate (user) {
      this.editedUser = ''
      this.editedUserEmail = ''
      this.editedUserPhone = ''
      this.editedUserSchool = ''
      this.editedUserRole = ''
      this.editedUserDate = user
    },
    checkSignedIn () {
      if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/profile/${this.$route.params.id}`)
          .then(response => {
            this.user = response.data.user
          })
          .catch(error => { this.setError(error, 'Something went wrong') })
      } else {
        this.$router.replace('/')
      }
    }
  },
  components: { Admin, Datepicker, Breadcrumb },
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
      }
    }
}
</script>
<style scoped>
  .userInfo {
    font-size: 1.2rem;
  }
</style>
