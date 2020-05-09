<template>
  <div class="signin">
  <form class="form-app form-signup mt-5" @submit.prevent="signup">
  <div class="d-flex">
    <h2 class="mt-3 mx-auto text-center" style="font-size:2.4rem;">Зарегистрироваться</h2></div>
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <div class="form-group mt-3 mx-auto">
      <label for="email" style="font-size:1.2rem;">Почта</label>
      <input v-model="email" type="email" class="form-control inputs w-100" id="email" placeholder="email@example.com">
    </div>
    <div class="form-group mt-3 mx-auto">
      <label for="name" style="font-size:1.2rem;">Имя</label>
      <input v-model="name" type="text" class="form-control inputs w-100" >
    </div>
    <div class="form-group mt-3 mx-auto">
      <label for="phone" style="font-size:1.2rem;">Телефон</label>
      <input v-model="phone" class="form-control inputs w-100" id="phone" >
    </div>
    <div class="form-group mt-3 mx-auto">
      <label for="password" class="mt-3" style="font-size:1.2rem;">Пароль</label>
      <input v-model="password" type="password" class="form-control inputs w-100" id="password" placeholder="Password">
    </div>
    <div class="form-group mt-3 mx-auto">
      <label for="password" class="mt-3" style="font-size:1.2rem;">Подтверждения пароля</label>
      <input v-model="password_confirmation" type="password" class="form-control inputs w-100" id="password_confirmation" placeholder="Password Confirmation">
    </div>
    <div class="form-group mt-3 mx-auto">
    <button type="submit" class="btn btnMsg mb-3 mt-3 w-100">Зарегистрироваться</button>
      <div></div>
      <router-link to="/">Войти</router-link>
      <br />
      <router-link to="/forgot_password">Забыли пароль?</router-link>
    </div>
  </form>
  </div>
</template>

<script>
import Main from '@/components/layouts/Main'
export default {
  name: 'Signup',
  data () {
    return {
      email: '',
      password: '',
      password_confirmation: '',
      error: '',
      phone: '',
      name: '',
      branch_id: 1
    }
  },
  created () {
    this.$emit('update:layout', Main)
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signup () {
      this.$http.plain.post(`${this.$store.getters.getCurrentCity.slug}/signup`, { email: this.email, phone: this.phone, password: this.password, password_confirmation: this.password_confirmation, name: this.name, branch_id: this.branch_id })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupSuccessful (response) {
      if (!response.data.csrf) {
        this.signupFailed(response)
        return
      }
      this.$http.plain.get(`${this.$store.getters.getCurrentCity.slug}/me`)
        .then(meResponse => {
          this.$store.commit('setCurrentUser', { currentUser: meResponse.data, csrf: response.data.csrf })
          this.error = ''
          this.$router.replace('/')
        })
        .catch(error => this.signupFailed(error))
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Что-то пошло не так'
      this.$store.commit('unsetCurrentUser')
    },
    checkSignedIn () {
      if (this.$store.state.signedIn) {
        this.$router.replace('/todos')
      }
    }
  },
  components: {Main}
}
</script>
<style lang='scss' scoped>
  .signin {
    padding-top: 5%;
  }
    .form-group{
  width: 35vw;
}
</style>
