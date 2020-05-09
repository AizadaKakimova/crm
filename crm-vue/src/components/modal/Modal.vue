<template>
  <div>
    <div class="modal fade fullscreen" id="menuModal" tabIndex="-1" role="dialog"
         aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header" style="border:0;">
            <button type="button" class="close btn btn-link" data-dismiss="modal" aria-hidden="true">
              <font-awesome-icon icon='times' class='icon'/>
            </button>
          </div>
          <div class="modal-body text-center">
            <ul style="list-style-type:none;" class="text-md-left ml-md-5 ulModal">
              <li class="ml-md-5"><a href="/signin"  data-text="О нас"
                                         class="aModal1" id="sign">Вход</a></li>
              <li class="ml-md-5"><a href="#" v-smooth-scroll="{ duration: 1000, offset: -50 }" data-text="О нас" class="aModal1">О нас</a></li>
              <li class="ml-md-5 big"><a href="#achievements" v-smooth-scroll="{ duration: 1000, offset: -50 }" data-text="Достижения" class="aModal1">Достижения</a></li>
              <li class="ml-md-5 big" @click="closeModal()">
                <!-- <a href="/courses" v-smooth-scroll="{ duration: 1000, offset: -50 }" data-text="Курсы" class="aModal1">Курсы</a> -->
                <router-link to="/courses" v-smooth-scroll="{ duration: 1000, offset: -50 }" data-text="Курсы" class="aModal1">Курсы</router-link>
              </li>
              <li class="ml-md-5 big" @click="closeModal()"><a href="#comments" v-smooth-scroll="{ duration: 1000, offset: -50 }" data-text="Отзывы" class="aModal1">Отзывы</a></li>
              <li class="ml-md-5 big" @click="closeModal()">
                <router-link to="/team" v-smooth-scroll="{ duration: 1000, offset: -50 }" data-text="Команда" class="aModal1">
                  Команда
                </router-link>
              </li>
            </ul>
      <div class="blueLineModal"></div>
            <ul style="list-style-type:none;" class="mt-md-5">
              <li class="mt-md-5" @click="closeModal()"><a href="#" data-text="Method/data" class="aModal2">Method /data</a></li>
              <li class="li1" @click="closeModal()"><a href="#" data-text="Method/pro" class="aModal2" style="color:#3333ff">Method
                /pro</a></li>
              <li @click="closeModal()"><a href="http://blog.method.kz/" data-text="Method/blog" class="aModal2">Method /blog</a></li>

            </ul>
          </div>
        </div>
        <!-- /.modal-content -->
      </div>
      <!-- /.modal-dialog -->
    </div>
    <div class="modal fade" id="exampleModal" tabIndex="-1" role="dialog" aria-labelledby="exampleModalLabel"
               aria-hidden="true">
            <div class="modal-dialog modal-md" role="document">
              <div class="modal-content">
                  <h1 class="my-4 ml-5 text-blue3" id="exampleModalLabel"><span>оставить заявку</span></h1>
                  <button type="button" class="close btn btn-link offset-10 mt-3" data-dismiss="modal" aria-label="Close" id = "close">
                    <font-awesome-icon icon='times' class='icon' style="color:#000"/>
                  </button>
                <div class="modal-body text-left align-items-center">
                  <form class="mt-3" @submit.prevent="addRequest()">
                    <div class="alert alert-danger" v-if="error">{{ error }}</div>
                      <div class="form-group col-10 ml-auto mr-auto">
                        <label class="modalLabel" htmlFor="inputEmail4">Как к вам обращаться?</label>
                        <input type="text" class="form-control inputs w-100" id="inputName" v-model.trim="request.name" required>
                      </div>
                    <div class="form-group mt-3 col-10 ml-auto mr-auto">
                      <label htmlFor="inputAddress" class="mt-3 modalLabel">Телефон<span class="colortext">*</span></label>
                      <input v-model.trim="request.phone" v-mask="'+# (###) ### ## ##'" type="text" class="form-control inputs w-100" id="inputAddress" required>
                    </div>
                    <!-- <div class="form-group mt-3">
                      <label htmlFor="inputAddress2" class="mt-3" :class="{invalid: $v.email.$error}"
                       type="email" id="email" label="Введите ваш email" @blur="$v.email.$touch()">E-mail</label>
                      <input type="email" class="form-control inputs" id="inputEmail4" :state="state" v-model.trim="request.email">
                      <p v-if="!$v.email.email">Проверьте вашу почту</p>
                    </div> -->
                    <div class="orm-group mt-3 col-10 ml-auto mr-auto">
                      <label htmlFor="exampleFormControlSelect1" class="mt-3 modalLabel">Выберите курс<span
                        class="colortext">*</span></label>
                        <select class="form-control inputs w-100" v-model="request.course_id">
                          <option v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">{{course.title}}</option>
                        </select>
                      <!-- <v-select id='v-select' v-model="selected" :options="courses"></v-select> -->
                      </div>
                    <div class="form-group mt-3 col-10 ml-auto mr-auto" v-if="branches.length>1">
                      <label htmlFor="exampleFormControlSelect1" class="mt-3 modalLabel">Какая точка для Вас ближе?</label>
                      <!-- <v-select id='v-select' :options="types" v-model="request.branch_id"></v-select> -->
                      <select class="form-control inputs w-100" v-model="request.branch_id">
                        <option v-for="branch in branches" v-bind:value="branch.id" v-bind:key="branch.id">{{ branch.address }}</option>
                      </select>
                    </div>
                    
                    <!-- <div class="form-group">
                      <label htmlFor="inputAddress5">Ваш вопрос или комментарий</label>
                       <input type="text" class="form-control inputs" id="inputAddress5">
                    </div> -->
                  <div class="form-group col-5 ml-auto mr-auto w-100">
                    <button type="submit" class="btn mt-4 btnMsg">Оставить заявку</button>
                  </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
          <!-- Modal -->
          <div class="modal fade" id="modalSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <h1 class="my-4 ml-7 text-blue3"><span>Спасибо!</span></h1>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  Ваша заявка успешно отправлена! <br/>
                  На номер {{this.request.phone}} отправленo СМС.
                </div>
              </div>
            </div>
                </div>

  </div>
</template>
<script>
import Main from '@/components/layouts/Main'
import {required, email} from 'vuelidate/lib/validators'
export default{
  name: 'menuModal',
  data () {
    return {
      newRequest: [],
      notice: '',
      error: '',
      request: {
        name: '',
        phone: '',
        branch_id: '',
        course_id: ''
      },
      courses: [],
      types: [],
      show: true,
      branches: []
    }
  },
  computed: {
    state () {
      if (this.request.email.length >= 4) {
        return true
      } else {
        return false
      }
    },
    invalidFeedback () {
      if (this.request.email.length > 4) {
        return ''
      } else if (this.request.email.length > 0) {
        return 'Enter at least 4 characters'
      } else {
        return 'Please enter something'
      }
    },
    validFeedback () {
      return this.state === true ? 'Спасибо' : ''
    }
  },
  validations: {
    email: {
      required: required,
      email: email
    }
  },
  created () {
    this.$emit('update:layout', Main)
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/branches`)
        .then(response => 
          this.branches = response.data.branches
          )
        .catch(error => {this.setError(error, 'Что-то пошло не так')})
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/courses`)
        .then(response => 
          this.courses = response.data.courses
          )
        .catch(error => {this.setError(error, 'Что-то пошло не так')})
  },
  methods: {
    close () {
      this.$emit('close')
    },
    // created () {
      
      // this.$http.secured.get('/')
      //   .then(response => { this.request = response.data })
      //   .catch(error => { this.setError(error, 'Something went wrong') })
    // },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
      this.notice = ''
    },
    addRequest () {
      const value = this.request
      if (!value) {
        return
      }
      if(this.$store.getters.getCurrentCity.id===1){
        
        // this.types.push()
      } else {
        this.shown=false
      }
      this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/send_request`, this.request)
        .then(response => this.createSuccessful(response))
        .catch(error => this.createFailed(error))
    },
    createSuccessful (response) {
      this.notice = 'Заявка отправлена'
      this.error = ''
      $('#exampleModal').modal('hide')
      $('#modalSuccess').modal('show')
    },
    createFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
    },
    closeModal () {
      $('#menuModal').modal('hide')
    },
    reloadPage () {
      window.location.reload()
    }
  },
  components: {Main}

}
</script>
