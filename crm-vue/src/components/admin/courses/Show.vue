<template>
    <div class="col-md-5 ml-auto mr-auto">
      <b-alert  v-if="error" show dismissible ariant="alert">
        {{ error }}
      </b-alert>
      <b-card class="card">
      <h4>Курс {{ course.title }} </h4>
      <ul class="list-group list-group-flush">
        <li class="list-group-item"> Цена: {{course.price}} </li>
        <li class="list-group-item"> Slug: {{course.slug}}</li>
        <li class="list-group-item"> Доступность: <span v-if="course.visible">Yes</span>
        <span v-else>No</span>
        </li>
      </ul>
      <br/>
      <router-link :to="`/admin/course/${course.id}/edit`"class="btn btn-success">
        <font-awesome-icon icon="pencil-alt"/>
      </router-link>
      </b-card>
    </div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'

export default {
  name: 'CourseShow',
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
      resource_url: '/admin/course/:id'
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/${this.$route.params.id}`)
        .then(response => {
          this.course = response.data.course
        })
        .catch(error => { this.setError(error, 'Ошибка') })
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users`)
        .then(response => {
          this.users = response.data.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses`)
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
          this.$swal('Deleted', 'Вы успешно удалили курс', 'success')
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
  components: { Admin }
}
</script>
