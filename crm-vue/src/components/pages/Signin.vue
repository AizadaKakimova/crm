<template>
  <div class="signin">
      <form class="form-app form-signin mt-5" @submit.prevent="signin">
    <div class="d-flex">
    <h2 class="mt-3 mx-auto text-center" style="font-size:2.4rem;">Вход</h2></div>

      <div class="form-group mt-3 mx-auto">
        <div class="alert alert-danger mx-auto" v-if="error">{{ error }}</div>
        <label for="email" style="font-size:1.2rem;">Email </label>
        <input v-model="email" type="email" class="form-control inputs w-100" placeholder="email@example.com">
      </div>
      <div class="form-group mt-3 mx-auto">
        <label for="password" class="mt-3" style="font-size:1.2rem;">Пароль</label>
        <input v-model="password" type="password" class="form-control inputs w-100" placeholder="Password">
      </div>
      <div class="form-group mt-3 mx-auto">
        <button type="submit" class="btn mb-3 mt-3 btnMsg w-100 mx-auto">Войти</button>
        <router-link to="/signup">Зарегистрироваться</router-link>
    <br />
        <router-link to="/forgot_password">Забыли пароль?</router-link>
        </div>
    </form>
  </div>
</template>
<script>
import Main from '@/components/layouts/Main'
export default {
  name: 'Signin',
  data () {
    return {
      email: '',
      password: '',
      error: ''
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
    signin () {
      this.$http.plain.post(`${this.$store.getters.getCurrentCity.slug}/signin`, { email: this.email, password: this.password })
        .then(response => this.signinSuccessful(response))
        .catch(error => this.signinFailed(error))
    },
    signinSuccessful (response) {
      if (!response.data.csrf) {
        this.signinFailed(response)
        return
      }
      this.$http.plain.get(`/${this.$store.getters.getCurrentCity.slug}/me`)
        .then(meResponse => {
          this.$store.commit('setCurrentUser', { currentUser: meResponse.data, csrf: response.data.csrf })
          this.error = ''
          console.log(response.data.csrf + meResponse.data.name)
          if (this.$store.getters.isAdmin) {
            this.$router.replace('/admin/dashboard')
          } else if (this.$store.getters.isManager) {
            this.$router.replace('/manager/dashboard')
          } else if (this.$store.getters.isInstructor){
            this.$router.replace('/instructor/dashboard')
          }else {
             this.$router.replace('/student/dashboard')
          }
        })
        .catch(error => this.signinFailed(error))
    },
    signinFailed (error) {
      this.error = 'Не авторизован'
      this.$store.commit('unsetCurrentUser')
    },
    checkSignedIn () {
      if (this.$store.state.signedIn) {
        if (this.$store.state.isAdmin) {
          this.$router.replace('/admin/dashboard/')
        } else if (this.$store.state.isManager) {
          this.$router.replace('/manager/dashboard/')
        } else if (this.$store.state.isInstructor) {
          this.$router.replace('/instructor/dashboard/')
        }
      }
    }
  },
  components: {Main}
}
</script>
<style lang='scss' scoped>
  .signin {
    padding-top: 10%;
    height: 100vh;
    align-items: center;
  }
  .form-group{
  width: 35vw;
}

</style>
