<template class="col-md-6">
    <!-- Modal Component -->
    <b-modal id="modal1" title="Оставить заявку">
      <div class="New Request">
        <router-view></router-view>
        <div class="alert alert-info" v-if="notice">{{ notice }}</div>
        <div class="alert alert-danger" v-if="error">{{ error }}</div>
        <form class="form-app form-new" @submit.prevent="addRequest()">
          <b-form-group
            type="name" id="name"
            label="Введите ваше имя"
            label-for="name">
          <b-form-input id="input2" v-model.trim="request.name"></b-form-input>
          </b-form-group>
          <b-form-group
            type="name" id="phone"
            label="Введите ваш телефон"
            label-for="name">
          <b-form-input id="input3" v-model.trim="request.phone" v-mask="'+# (###) ### ## ##'"></b-form-input>
          </b-form-group>
           <b-form-group class="form-group input" :class="{invalid: $v.email.$error}"
            type="email" id="email" label="Введите ваш email" @blur="$v.email.$touch()">
            <b-form-input id="input1" :state="state" v-model.trim="request.email"></b-form-input>
            <p v-if="!$v.email.email">Проверьте вашу почту</p>
          </b-form-group>
          <div class="form-group">
            <label>Откуда вы узнали о нас?</label>
            <select v-model="request.source" class="form-control" id="source">
              <option value='Поисковик'>Поисковик</option>
              <option value='Соц сети'>Соц сети</option>
              <option value='Рекомендация'>Рекомендация</option>
              <option value='Рассылка'>Рассылка</option>
              <option value='Биллбоард'>Биллбоард</option>
              <option value='Другое'>Другое</option>
            </select>
          </div>
            <!-- <p>{{$v.email.email}}</p> -->
          <button type="submit" class="btn btn-primary mb-4">Отправить заявку</button>
        </form>
      </div>
      <div slot="modal-footer">
      </div>
    </b-modal>
</template>
<script>
import Main from '@/components/layouts/Main'
import {required, email} from 'vuelidate/lib/validators'
export default {
  name: 'RequestModal',
  data () {
    return {
      newRequest: [],
      notice: '',
      error: '',
      request: {
        name: '',
        phone: '',
        email: '',
        source: ''
      }
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
  methods: {
    close () {
      this.$emit('close')
    },
    created () {
      this.$emit('update:layout', Main)
      // this.$http.secured.get('/')
      //   .then(response => { this.request = response.data })
      //   .catch(error => { this.setError(error, 'Something went wrong') })
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
      this.notice = ''
    },
    addRequest () {
      const value = this.request
      if (!value) {
        return
      }
      this.$http.secured.post('/admin/requests', this.request)
        .then(response => this.createSuccessful(response))
        .catch(error => this.createFailed(error))
    },
    createSuccessful (response) {
      this.notice = 'Заявка отправлена'
      this.error = ''
    },
    createFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.error = 'Исправьте ошибки'
    }
  },
  components: {Main}
}
</script>
<style scoped>

.input.invalid label{
  color: red;
}
.input.invalid input{
  border: 1px solid red;
  background-color: red;
}
</style>
