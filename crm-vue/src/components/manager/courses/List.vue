<template>
  <div class="courses col-md-10">
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <h3>Courses
      <router-link :to="`/manager/courses/new`">
        <b-btn class="btn btn-sm btn-success"><i class="far fa-plus-square"></i>Добавить</b-btn>
      </router-link>
    </h3>
    <modal></modal>
    <table class="table">
      <thead>
      <tr>
        <th>id</th>
        <th>title</th>
        <th>filename</th>
        <th>price</th>
        <th>slug</th>
        <th>shown</th>
        <th>actions</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="course in courses" :key="course.id" :course="course">
        <td>
          {{ course.id }}
        </td>
        <td>
          <router-link :to="`/manager/courses/${course.id}`">
            {{ course.title }}
          </router-link>
        </td>
        <td>{{ course.file_name }}</td>
        <td>{{ course.price }}</td>
        <td>{{ course.slug }}</td>
        <td>{{ course.shown }}</td>
        <td>
          <router-link :to="`/manager/courses/${course.id}`">
            <button class="btn btn-sm btn-warning" :v-b-modal="course.id+'modal'">
              <i class="far fa-edit">{{course.id}}</i>
            </button>
          </router-link>
          <button class="btn btn-sm btn-danger" @click="alertDisplay(course)">
            <i class="fa fa-trash-alt float-right"></i>
          </button>
        </td>
      </tr>
      </tbody>
    </table>
    <editmodal></editmodal>
  </div>
</template>
<script>
import Manager from '@/components/layouts/manager/Manager'
import modal from '@/components/modal/CourseModal.vue'
import editmodal from '@/components/modal/EditCourseModal.vue'

export default {
  name: 'CourseListManager',
  data () {
    return {
      error: '',
      courses: [],
      course: ''
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    if (this.$store.state.signedIn && this.$store.getters.isManager) {
      this.$http.secured.get('/manager/courses')
        .then(response => {
          this.courses = response.data
        })
        .catch(error => {
          this.setError(error, 'Something went wrong')
        })
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
      this.$http.secured.delete(`/manager/courses/${course.id}`)
        .then(response => this.courses.splice(this.courses.indexOf(course), 1))
        .catch(error => this.setError(error, 'Cannot delete course'))
    },
    editCourse (course) {
      this.editedRequest = course
    },
    updateCourse (course) {
      this.editedRequest = ''
      this.$http.secured.patch(`/manager/courses/${course.id}`)
        .catch(error => this.setError(error, 'Cannot update Course'))
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
          this.$swal('Deleted', 'You successfully deleted this file', 'success')
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
  components: {Manager, modal, editmodal}
}
</script>
<style lang="css">
</style>
