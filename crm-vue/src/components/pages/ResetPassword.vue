<template>
  <form class="form-app form-reset-password" @submit.prevent="reset">
  <div class="d-flex">
    <h2 class="mt-3 mx-auto text-center" style="font-size:2.4rem;">Восстановления пароля</h2></div>
    <div class="alert alert-info" v-if="notice">{{ notice }}</div>
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <div class="form-group mt-3 mx-auto">
      <label for="password">Новый пароль</label>
      <input v-model="password" type="password" class="form-control" id="password" placeholder="Password">
    </div>
    <div class="form-group mt-3 mx-auto">
      <label for="password">Подтверждение нового пароля</label>
      <input v-model="password_confirmation" type="password" class="form-control inputs w-100" id="password_confirmation" placeholder="Password Confirmation">
    </div>
  <div class="form-group mt-3 mx-auto">
    <button type="submit" class="btn btnMsg my-3">Восстановить пароль</button></div>
    <div>
      <router-link to="/">Войти</router-link>
    </div>
  </form>
</template>

<script>
export default {
  name: 'ResetPassword',
  data () {
    return {
      password: '',
      password_confirmation: '',
      error: '',
      notice: ''
    }
  },
  created () {
    this.checkPasswordToken()
  },
  methods: {
    reset () {
      this.$http.plain.patch(`${this.$store.getters.getCurrentCity.slug}/password_resets/${this.$route.params.token}`, { password: this.password, password_confirmation: this.password_confirmation })
        .then(response => this.resetSuccessful(response))
        .catch(error => this.resetFailed(error))
    },
    resetSuccessful (response) {
      this.notice = 'Your password has been reset successfully! Please sign in with your new password.'
      this.error = ''
      this.password = ''
      this.password_confirmation = ''
    },
    resetFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Что-то пошло не так'
      this.notice = ''
    },
    checkPasswordToken () {
      this.$http.plain.get(`/password_resets/${this.$route.params.token}`)
        .catch(error => {
          this.resetFailed(error)
          this.$router.replace('/')
        })
    }
  }
}
</script>

