<!-- Это для добовления курса с попап но с глюком. Не нужная просто на всякие случай не удалять.   -->
<template class="col-md-6">
    <!-- Modal Component -->
    <b-modal id="newcourse" title="Add new course">
      <div class="Edit Course">
        <router-view></router-view>
        <div class="alert alert-info" v-if="notice">{{ notice }}</div>
        <div class="alert alert-info" v-if="error">{{ error }}</div>
        <form class="form-app form-new" @submit.prevent="addCourse">
          <b-form-group
            type="name" id="name"
            label="Название нового курса"
            label-for="name">
          <b-form-input id="input" v-model.trim="course.title"></b-form-input>
          </b-form-group>
          <b-form-group
            type="name" id="file"
            label="Название файла"
            label-for="file">
          <b-form-input id="input3" v-model.trim="course.file_name"></b-form-input>
          </b-form-group>
          <b-form-group
          label="Цена"
          >
            <b-form-input
              id="input1"
              type="number"
              v-model.trim="course.price">
            </b-form-input>
          </b-form-group>
          <b-form-group
            label="Slug"
          >
            <b-form-input
              id="input1"
              type="text"
              v-model.trim="course.slug">
            </b-form-input>
          </b-form-group>
          <button type="submit" class="btn btn-primary mb-4">Добавить курс</button>
        </form>
      </div>
      <div slot="modal-footer">
      </div>
    </b-modal>
</template>
<script>
import Main from '@/components/layouts/Main'
export default {
  name: 'modal',
  data () {
    return {
      notice: '',
      error: '',
      course: {
        title: '',
        price: '',
        slug: '',
        file_name: ''
      }
    }
  },
  methods: {
    close () {
      this.$emit('close')
    },
    addCourse () {
      const value = this.course
      if (!value) {
        return
      }
      this.$http.secured.post('/admin/courses', this.course)
      this.$http.secured.get('/admin/courses')
        .then(response => {
          this.courses = response.data
          this.$emit(this.courses.push(this.course))
          this.createSuccessful(response)
        })
        .catch(error => this.createFailed(error))
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
      this.notice = ''
    },
    createSuccessful (response) {
      this.notice = 'Курс добавлен'
      this.error = ''
    },
    createFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = 'Исправьте ошибки'
    }
  },
  components: {Main}
}
</script>
<style lang="css" scoped>

.input.invalid label{
  color: red;
}
.input.invalid input{
  border: 1px solid red;
  background-color: red;
}
</style>
