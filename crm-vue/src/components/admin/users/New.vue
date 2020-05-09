<template>
  <div class="New User col-sm-6 mx-auto mt-5">
    <b-alert  v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert  v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <b-card header="Новый пользователь" class="card">
    <form @submit.prevent="addUser" class="form-app form-edit">
      <div class="form-group">
        Имя: <input type="text" v-model="user.name" placeholder="Введите имя" class="form-control mr-sm-2"
                      id="input-icon-left" name="input-icon-left" required autocomplete="off"/>
      </div>
      <div class="form-group mt-3">
        Телефон:
        <input type="text" v-model="user.phone" placeholder="Введите телефон" class="form-control mr-sm-2"
               id="input-icon-left" name="input-icon-left" required autocomplete="off"/>
      </div>
      <div class="form-group mt-3">
        Почта:
        <input type="text" v-model="user.email" placeholder="Введите почту" class="form-control mr-sm-2"
               id="input-icon-left" name="input-icon-left" required autocomplete="off"/>
      </div>
      <div class="form-group mt-3">
        Роль:
        <select class="form-control" v-model="user.role" id="role">
            <option value='admin'>Админ</option>
            <option value='manager'>Менеджер</option>
            <option value='user'>Пользователь</option>
            <option value='instructor'>Преподаватель</option>
        </select>
      </div>

      <div class="form-group row">
        <div class="col-sm-10">
          <button type="submit" class="btn btn-primary">Добавить</button>
      </div>
    </div>
  </form>
  </b-card>
  </div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
export default {
  name: 'UserNew',
  data () {
    return {
      error: '',
      notice: '',
      user: {
        name: '',
        phone: '',
        email: '',
        role: 'user'
      }
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
    // alert(this.$store.getters.getCurrentCity.slug)
  },
  methods: {
    addUser () {
      this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/user/new`, this.user)
        .then(response => { this.createSuccessful(response) })
        .catch(error => { this.setError(error, 'Пожалуйста, проверьте поля!') })
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createSuccessful (response) {
      this.notice = 'Админ добавлен'
      this.error = ''
    },
    createFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    checkSignedIn () {
      if (!(this.$store.state.signedIn && this.$store.getters.isAdmin)) {
        this.$router.replace('/')
      }
    }
  },
  components: { Admin }
}
</script>
