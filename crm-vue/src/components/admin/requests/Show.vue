<template>
  <div class="col-md-10 ml-auto mr-auto">

    <div class="row">
    <div class="col-md-6">
      <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert v-if="notice" v-model="showDismissibleAlert" dismissible variant="success">
      {{ notice }}
    </b-alert>
    <b-card header="Заявка" class="card">
      <tr>
            <td width="50%">Имя:</td>
            <td v-show="request !== editedRequest" @dblclick="editRequest(request)" class="courseInfo">
            <span v-if="request.name===null" class="spanNull" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
              <span v-else>{{ request.name }}</span></td>
              <td v-show="request === editedRequest"
       v-on:blur="request.editedRequest=false; $emit('update')">
              <input class="form-control" v-if="request === editedRequest" v-click-outside="checkRequest" v-request-focus v-model="request.name" @keyup.enter="update(editedRequest)"/></td>
          </tr>
    <tr>
            <td>Телефон:</td>
            <td v-show="request !== editedRequestPhone" @dblclick="editRequestPhone(request)">
            <span v-if="request.phone===null" class="spanNull" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
              <span v-else>{{ request.phone }}</span></td>
              <td v-show="request === editedRequestPhone"
       v-on:blur="request.editedRequest=false; $emit('update')">
              <input class="form-control" v-if="request === editedRequestPhone" v-click-outside="checkPhone" v-request-focus v-model="request.phone" @keyup.enter="update(editedRequest)" v-mask="'+#-(###)-###-##-##'"/></td>
          </tr>
   <tr>
            <td>Почта:</td>
            <td v-show="request !== editedRequestEmail" @dblclick="editRequestEmail(request)">
              <span v-if="request.email===null" class="spanNull" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
              <span v-else>{{ request.email }}</span></td>
              <td v-show="request === editedRequestEmail"
       v-on:blur="request.editedRequest=false; $emit('update')">
              <input class="form-control" v-if="request === editedRequestEmail" v-click-outside="checkEmail" v-request-focus v-model="request.email" @keyup.enter="update(editedRequest)"/></td>
          </tr>
 <tr>
            <!-- <td>Курс:</td>
   <td v-show="request !== editedRequestCourse" @dblclick="editRequestCourse(request)" v-if="request.course_id">
     <span v-if="request.course_id === null" class="spanNull" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
              <span v-else>{{ courses[request.course_id].title  }}</span>
   </td>
   <td v-show="request === editedRequestCourse">
     <select v-model="request.course_id" class="form-control" v-if="request === editedRequestCourse" v-click-outside="checkCourse">
     <option v-if="course.visible" v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">
       {{course.title}}
     </option>
   </select></td> -->
          </tr>
<tr>
  <td>Статус:</td>
  <td v-show="request !== editedRequestStatus" @dblclick="editRequestStatus(request)">
    {{request.status}}
  </td>
  <td v-show="request === editedRequestStatus" ><select v-model="request.status" v-if="request === editedRequestStatus"
                                                        v-click-outside="checkStatus" id="status" class="form-control">
    <option value='Новая'>Новая</option>
    <option value='Обработана'>Обработана</option>
    <option value='В процессе'>В процессе</option>
    <option value='В группе'>В группе</option>
  </select></td>
</tr>
      <tr>
        <td>Ресурс:</td>
        <td v-show="request !== editedRequestSource" @dblclick="editRequestSource(request)">{{request.source}}</td>
        <td v-show = "request === editedRequestSource" v-on:blur="user.editedRequest=false; $emit('update')">
          <select v-model="request.source" v-if="request === editedRequestSource" v-click-outside="checkSource" id="source" class="form-control">
          <option value='Поисковик'>Поисковик</option>
          <option value='Соц сети'>Соц сети</option>
          <option value='Рекомендация'>Рекомендация</option>
          <option value='Рассылка'>Рассылка</option>
          <option value='Биллбоард'>Биллбоард</option>
          <option value='Другое'>Другое</option>
        </select>
        </td>
      </tr>

      <div class="form-group row">
        <div class="col-sm-6">
          <button v-if="request.status === 'В группе'" class="mt-3 btn btn-info" @click="accept(editedRequestStatus)">Добавить
          </button>
          <button v-else type="submit" class="mt-3 btn btn-primary" @click="update()">Обновить</button>
        </div>
      </div>
    </b-card>
          <router-link to="/admin/requests">Назад к заявкам</router-link>
    </div>
  <div class="col-md-5">
    <b-card class="card">
      <div v-if="request.user_id || show===true">
        <router-link :to="`/${this.$store.getters.getCurrentCity.slug}/admin/users/${request.user_id}`">
          Пользователь
        </router-link>
      </div>
      <div v-else>
        <h4>Пользователь не был создан</h4>
      </div>
    </b-card>
    </div>
      </div>
  </div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
export default {
  name: 'RequestShow',
  data() {
    return {
      error: '',
      notice: '',
      request: {},
      requests: [],
      courses: {},
      editedRequest: '',
      editedRequestEmail: '',
      editedRequestPhone: '',
      editedRequestSource: '',
      editedRequestStatus: '',
      editedRequestCourse: '',
      request1: {},
      showDismissibleAlert: false,
      show: false
    }
  },
  created() {
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
    this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/`)
      .then(response => {
        this.courses = response.data
      })
      .catch(error => {
        this.setError(error, 'Something went wrong')
      })
  },
  methods: {
    update() {
      this.editedRequest = ''
      this.editedRequestEmail = ''
      this.editedRequestPhone = ''
      this.editedRequestSource = ''
      this.editedRequestStatus = ''
      this.editedRequestCourse = ''
      this.showDismissibleAlert = ''
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/requests/${this.$route.params.id}`, {
          request: {
            email: this.request.email,
            status: this.request.status,
            source: this.request.source,
            name: this.request.name,
            phone: this.request.phone,
            course_id: this.request.course_id
          }
        })
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    addUserToRequest(user) {
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/requests/${this.$route.params.id}`, {
          request: {
            user_id: user.id
          }
        })
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    checkRequest () {
      if (this.request1.name !== this.editedRequest.name){
        this.update()
      }
      else {
        this.editedRequest = ''
      }
    },
    checkEmail () {
      if (this.request1.email !== this.editedRequestEmail.email){
        this.update()
      }
      else {
        this.editedRequestEmail = ''
      }
    },
    checkPhone () {
      if (this.request1.phone !== this.editedRequestPhone.phone){
        this.update()
      }
      else {
        this.editedRequestPhone = ''
      }
    },
    checkSource () {
      if (this.request1.source !== this.editedRequestSource.source){
        this.update()
      }
      else {
        this.editedRequestSource = ''
      }
    },
    checkStatus () {
      if (this.request1.status !== this.editedRequestStatus.status){
        this.update()
      }
      else {
        this.editedRequestStatus = ''
      }
    },
    checkStatus () {
      if (this.request1.course !== this.editedRequestCourse.course){
        this.update()
      }
      else {
        this.editedRequestCourse = ''
      }
    },
    editRequest (request) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/requests/${this.$route.params.id}`)
          .then(response => {
            if (this.$store.getters.currentUserId === response.data.id) {
              this.$router.replace('/')
              return
            }
            this.request1 = response.data
            this.editedRequestEmail = ''
            this.editedRequestPhone = ''
            this.editedRequestSource = ''
            this.editedRequestStatus = ''
            this.editedRequestCourse = ''
            this.editedRequest = request
            })
    },
    editRequestEmail (request) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/requests/${this.$route.params.id}`)
          .then(response => {
            if (this.$store.getters.currentUserId === response.data.id) {
              this.$router.replace('/')
              return
            }
            this.request1 = response.data
            this.editedRequest = ''
            this.editedRequestPhone = ''
            this.editedRequestSource = ''
            this.editedRequestStatus = ''
            this.editedRequestCourse = ''
            this.editedRequestEmail = request
          })
    },
    editRequestPhone (request) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/requests/${this.$route.params.id}`)
          .then(response => {
            if (this.$store.getters.currentUserId === response.data.id) {
              this.$router.replace('/')
              return
            }
            this.request1 = response.data
            this.editedRequest = ''
            this.editedRequestEmail = ''
            this.editedRequestSource = ''
            this.editedRequestStatus = ''
            this.editedRequestCourse = ''
            this.editedRequestPhone = request
          })
    },
    editRequestSource (request) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/requests/${this.$route.params.id}`)
          .then(response => {
            if (this.$store.getters.currentUserId === response.data.id) {
              this.$router.replace('/')
              return
            }
            this.request1 = response.data
            this.editedRequest = ''
            this.editedRequestEmail = ''
            this.editedRequestPhone = ''
            this.editedRequestStatus = ''
            this.editedRequestCourse = ''
            this.editedRequestSource = request
          })
    },
    editRequestStatus (request) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/requests/${this.$route.params.id}`)
          .then(response => {
            if (this.$store.getters.currentUserId === response.data.id) {
              this.$router.replace('/')
              return
            }
            this.request1 = response.data
            this.editedRequest = ''
            this.editedRequestEmail = ''
            this.editedRequestPhone = ''
            this.editedRequestSource = ''
            this.editedRequestCourse = ''
            this.editedRequestStatus = request
          })
    },
    editRequestCourse (request) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/requests/${this.$route.params.id}`)
          .then(response => {
            if (this.$store.getters.currentUserId === response.data.id) {
              this.$router.replace('/')
              return
            }
            this.request1 = response.data
            this.editedRequest = ''
            this.editedRequestEmail = ''
            this.editedRequestPhone = ''
            this.editedRequestSource = ''
            this.editedRequestStatus = ''
            this.editedRequestCourse = request
          })
    },
    updateSuccessful(response) {
      this.notice = 'Заявка обновлена'
      this.error = ''
      // this.$router.go('/admin/requests')
    },
    createSuccessful(response) {
      this.notice = 'Пользователь добавлен'
      this.error = ''
    },
    updateFailed(error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    setError(error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
      this.notice = ''
    },
    checkSignedIn() {
      if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/requests/${this.$route.params.id}`)
          .then(response => {
            if (this.$store.getters.currentUserId === response.data.id) {
              this.$router.replace('/')
              return
            }
            this.request = response.data
          })
          .catch(error => {
            this.setError(error, 'Что-то пошло не так')
          })
      } else {
        this.$router.replace('/')
      }
    },
    accept(request) {
      alert(request.status)
      this.$http.secured.post('/admin/user/new', {
          name: request.name,
          email: request.email,
          phone: request.phone,
          status: request.status,
          role: 'user'
        })
        .then(response => {
          console.log(response)
          this.addUserToRequest(response.data)
          this.createSuccessful(response)
          // this.show = true
        })
        .catch(error => {
          this.setError(error, 'Пожалуйста, проверьте поля!')
        })
    }
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
      }
    },
  components: {
    Admin
  }
}
</script>
