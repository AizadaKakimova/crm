<template>
<div class="row">
  <div class="col-md-5 ml-auto mr-auto">
    <b-alert  v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert  v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <b-card header = "Добавить ученика" class="card">
    <form class="form-app form-edit" @submit.prevent="addEnrollment">
      <div class="form-group">
        Группа: <strong>{{group.title}}</strong>
      </div>
      <div class="form-group">
        ID пользователя:
        <input type="number" autocomplete="off" v-model="enrollment.user_id" placeholder="" class="form-control mr-sm-2" id="input-icon-left" name="input-icon-left" required/>
      </div>
      <div class="form-group">
        Ожидаемая сумма:<input type="number" v-model="enrollment.expected_value" placeholder="" class="form-control mr-sm-2" id="input-icon-left" name="input-icon-left" required/>
      </div>
      <div class="form-group">
        Статус:
        <select class="form-control" v-model="enrollment.status">
          <option value='skipped'>пропущено</option>
          <option value='dropped'>сбросано</option>
          <option value='enrolled' selected>зачислено</option>
        </select>
      </div>
      <br/>
      <button type="submit" class="btn btn-primary mb-3">Создать</button>
      <div>
        <router-link to="/admin/groups/">Назад к таблице Групп</router-link>
      </div>
  </form>
  </b-card>
  </div>
</div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
export default {
  name: 'EnrollmentNew',
  data () {
    return {
      error: '',
      notice: '',
      group: '',
      enrollment: {
        user_id: '',
        group_id: '',
        status: '',
        expected_value: ''
      }
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
    console.log(this.$route.params.id)
    this.getGroup()
  },
  methods: {
    addEnrollment () {
      this.enrollment.group_id = this.group.id
      this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/enrollments/new`, this.enrollment)
        .then(response => { this.createSuccessful(response) })
        .catch(error => { this.setError(error, 'Пожалуйста, проверьте поля!') })
    },
    getGroup() {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/groups/${this.$route.params.slug}`)
        .then(response => 
        this.group = response.data.group
        )
        .catch(error => this.setError(error, 'Невозможно удалить зачисления'))
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createSuccessful (response) {
      this.notice = 'Ученик добавлен'
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
