<template>
<div>
<div class = "row">
<div class = "col-xs-12 col-md-12">
  <b-card header = "Таблица курсов" class="card">
    <b-alert  v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
      <div class="alert alert-danger" v-if="error">{{ error }}</div>
        <router-link :to="`/admin/course/new`">
          <button class="btn btn-primary">
            <font-awesome-icon icon="plus-square"/> Добавить
          </button>
        </router-link>
      <modal></modal>
      <div class = "table-responsive table-hover mt-3">
      <table class="table first-td-padding table-striped">
        <thead>
          <tr>
            <th>ID</th>
            <th>Название</th>
            <th>Название файла</th>
            <th>Цена</th>
            <th>Slug</th>
            <th>Видимость</th>
            <th>Действия</th>
          </tr>
        </thead>
        <tbody>
        <tr v-for="course in courses" :key="course.id" :course="course" @dblclick="editCourse(course)">
              <td>
                {{ course.id }}
              </td>
<td>
        <div v-show="course !== editedCourse">
              <router-link :to="`/admin/course/${course.id}`">
                  {{ course.title }}
                </router-link>
            </div>
            <div v-show="course === editedCourse"
                v-on:blur="course.editedCourse=false; $emit('update')">
              <input v-request-focus v-model="course.title"/>
            </div>
  </td>
              <td>
            <div v-show="course !== editedCourse">
                  {{ course.file_name }}
            </div>
            <div v-show="course === editedCourse"
                v-on:blur="course.editedCourse=false; $emit('update')">
              <input v-request-focus v-model="course.file_name"/>
            </div>
              </td>
              <td><div v-show="course !== editedCourse">
                  {{ course.price }}
            </div>
            <div v-show="course === editedCourse"
                v-on:blur="course.editedCourse=false; $emit('update')">
              <input v-request-focus v-model="course.price"/>
            </div></td>
              <td><div v-show="course !== editedCourse">
                  {{ course.slug }}
            </div>
            <div v-show="course === editedCourse"
                v-on:blur="course.editedCourse=false; $emit('update')">
              <input v-request-focus v-model="course.slug"/>
            </div></td>
              <td><div v-show="course !== editedCourse">
                  {{ course.shown }}
            </div>
            <div v-show="course === editedCourse"
                v-on:blur="course.editedCourse=false; $emit('update')">
              <select v-model="course.shown" v-request-focus
                      @keyup.enter="updateCourse(course)" id="course" :key="course.shown">
                <option v-for="shown in showns" :value="shown" :key="shown">{{ shown }}</option>
              </select>
            </div></td>
              <td>
                <div v-show="course !== editedCourse">
                <router-link :to="`/admin/course/${course.id}`">
                    <font-awesome-icon icon="pencil-alt" :v-b-modal="course.id+'modal'"/>
                </router-link>
                  <font-awesome-icon icon="trash" class="red" @click="alertDisplay(course)"/>
</div>
  <div v-show="course === editedCourse" @click="updateCourse(editedCourse)">
              <button type="button" class="btn btn-sm btn-warning" name="button">Изменить</button>
              </div>
              </td>
          </tr>
        </tbody>
      </table>
      </div>
      <editmodal></editmodal>
  </b-card>
</div>
</div>
</div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import modal from '@/components/modal/CourseModal.vue'
import editmodal from '@/components/modal/EditCourseModal.vue'
export default {
  name: 'CourseList',
  data () {
    return {
      error: '',
      courses: [],
      course: '',
      editedCourse: '',
      notice: '',
      showns : [ 'true', 'false' ]
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses`)
        .then(response => { this.courses = response.data.courses })
        .catch(error => { this.setError(error, 'Что-то пошло не так') })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    showModal () {
      this.isModalVisible = true
    },
    closeModal () {
      this.isModalVisible = false
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    showRequestLink () {
      return this.$store.getters.isAdmin || this.$store.getters.isManager
    },
    removeCourse (course) {
      this.$http.secured.delete(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/${course.id}`)
        .then(response => this.courses.splice(this.courses.indexOf(course), 1))
        .catch(error => this.setError(error, 'Невозможно удалить курс'))
    },
    editCourse (course) {
      this.editedCourse = course
    },
    updateCourse (course) {
      this.editedCourse = ''
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/${course.id}`, course)
        .then(response => this.updateSuccessful(response))
        .catch(error => this.setError(error, 'Невозможно обновить курс'))
    },
    updateSuccessful (response) {
      this.notice = 'Курс обновлен'
      this.error = ''
    },
    alertDisplay (course) {
      this.$swal({
        title: 'Вы уверены что хотите удалить курс?',
        type: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Да, удалить!',
        cancelButtonText: 'Нет, оставить!',
        showCloseButton: true,
        showLoaderOnConfirm: true
      }).then((result) => {
        if (result.value) {
          this.$swal('Deleted', 'Вы успешно удалили курс', 'success')
          this.removeCourse(course)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  directives: {
    'course-focus': function (el) {
      el.focus()
    }
  },
  components: { Admin, modal, editmodal }
}
</script>
