<template>
  <div class="courses col-md-10">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <h3>Курс {{ course.title }} </h3>
    <ul>
      <li> Price: {{course.price}}</li>
      <li> Slug: {{course.slug}}</li>
      <li> Available: <span v-if="course.visible">Yes</span>
        <span v-else>No</span>
      </li>
    </ul>
    <router-link :to="`/manager/courses/${course.id}/edit`">
      <button type="button" name="button">Edit</button>
    </router-link>
  </div>
</template>
<script>
import Manager from '@/components/layouts/manager/Manager'

export default {
  name: 'CourseShowManager',
  data () {
    return {
      error: '',
      users: {},
      title: '',
      course: '',
      group: {
        title: ''
      },
      'enrollment': '',
      enrollments: '',
      enrollments_enrolled: {
        status: ''
      },
      enrollments_dropped: {
        status: ''
      },
      enrollments_skipped: '',
      courses: [],
      editedCourse: '',
      resource_url: '/manager/course/:id'
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    if (this.$store.state.signedIn && this.$store.getters.isManager) {
      this.$http.secured.get(`/manager/courses/${this.$route.params.id}`)
        .then(response => {
          this.course = response.data.course
        })
        .catch(error => {
          this.setError(error, 'Error')
        })
      this.$http.secured.get('/manager/users')
        .then(response => {
          this.users = response.data.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
      this.$http.secured.get('/manager/courses')
        .then(response => {
          this.courses = response.data.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    alertDisplay (group) {
      this.$swal({
        title: 'Вы уверены что хотите удалить?',
        type: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Да, удалить!',
        cancelButtonText: 'Нет, оставить!',
        showCloseButton: true,
        showLoaderOnConfirm: true
      }).then((result) => {
        if (result.value) {
          this.$swal('Deleted', 'You successfully deleted this file', 'success')
          this.removeEnrollment(group)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  directives: {
    'enrollment-focus': function (el) {
      el.focus()
    }
  },
  components: {Manager}
}
</script>
