<template>
  <div class="row">
    <div class = "col-md-6 mx-auto">
    <b-alert  v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert  v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <b-card class="card" header = "Новый курс">
    <form class="form-app form-edit" @submit.prevent="addCourse">
      <b-form-group type="name" id="name" label="Название нового курса" label-for="name">
        <b-form-input id="input" v-model.trim="course.title" autocomplete="off"></b-form-input>
      </b-form-group>
      <b-form-group type="name" id="file" label="Название файла" label-for="file">
        <b-form-input id="input3" v-model.trim="course.file_name" autocomplete="off"></b-form-input>
      </b-form-group>
      <b-form-group label="Цена">
        <b-form-input id="input1" type="number" v-model.trim="course.price" autocomplete="off"></b-form-input>
      </b-form-group>
      <b-form-group label="Slug" >
        <b-form-input required id="input1" type="text" v-model.trim="course.slug" autocomplete="off"> </b-form-input>
      </b-form-group>
      <b-form-group type="name" id="description" label="Описание курса" label-for="name">
        <b-form-input id="input" v-model.trim="course.description" autocomplete="off"></b-form-input>
      </b-form-group>
      <b-form-group type="name" id="image_link" label="Картинка" label-for="name">
        <b-form-input id="input" v-model.trim="course.image_link" autocomplete="off"></b-form-input>
      </b-form-group>
      <b-form-group type="name" id="level" label="Уровень" label-for="name">
        <b-form-input id="input" v-model.trim="course.level" autocomplete="off"></b-form-input>
      </b-form-group>
      <b-form-group type="name" id="duration" label="Продлжительность" label-for="name">
        <b-form-input id="input" v-model.trim="course.duration" autocomplete="off"></b-form-input>
      </b-form-group>
      <button type="submit" class="btn btn-primary mb-3">Создать</button>
      <div>
        <router-link to="/admin/courses">Назад к таблице курсов</router-link>
      </div>
    </form>
    </b-card>
    </div>
  </div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
export default {
  name: 'CourseNew',
  data () {
    return {
      error: '',
      notice: '',
      course: {
        title: '',
        file_name: '',
        price: '',
        slug: '',
        description: '',
        image_link: ''
      }
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
},
  methods: {
    addCourse () {
      this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/new`, this.course)
        .then(response => { this.createSuccessful(response) })
        .catch(error => { this.setError(error, 'Пожалуйста, проверьте поля!') })
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createSuccessful (response) {
      this.notice = 'Курс добавлен'
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
