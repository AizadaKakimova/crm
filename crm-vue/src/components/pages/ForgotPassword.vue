<template>
  <div class="signin">
  <form class="form-app form-forgot-password mt-5" @submit.prevent="submit">
  <div class="d-flex">
    <h2 class="mt-3 mx-auto text-center" style="font-size:2.4rem;">Сброс пароля</h2></div>
    <div class="alert alert-info" v-if="notice">{{ notice }}</div>
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <div class="form-group mt-3 mx-auto">
      <label for="email" style="font-size:1.2rem;">Email</label>
      <input v-model="email" type="email" class="form-control inputs w-100" id="email" placeholder="email@example.com">
    </div>
    <div class="form-group mt-3 mx-auto">
      <button type="submit" class="btn btnMsg mt-5 w-100">Сбросить</button></div>
  </form>
</div>
</template>

<script>
export default {
  name: 'ForgotPassword',
  data () {
    return {
      email: '',
      error: '',
      notice: ''
    }
  },
  methods: {
    submit () {
      this.$http.plain.post(`${this.$store.getters.getCurrentCity.slug}/password_resets`, { email: this.email })
        .then(() => this.submitSuccessful())
        .catch(error => this.submitFailed(error))
    },
    submitSuccessful () {
      this.notice = 'Email with password reset instructions had been sent.'
      this.error = ''
      this.email = ''
    },
    submitFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
    }
  }
}
</script>
<style scoped>
    .form-group{
  width: 35vw;
}
</style>
