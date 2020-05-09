<template>
    <div class="row">
      <div class="col-10">
        <b-card header="Группа">
          <div class = "table-responsive table-hover table-striped">
            <table class="table first-td-padding table-striped">
              <thead>
              <tr>
                <th>Название</th>
                <th>Курс</th>
                <th>Преподаватель</th>
              </tr>
              </thead>
              <tbody>
              <tr v-for="group in groups">
                <td><router-link :to="`/student/groups/${group.slug}`">{{group.title}}</router-link></td>
                <td>{{courses[group.course_id].title}}</td>
                <td><router-link :to="`/student/instructor/${instructors[group.instructor_id].id}`">{{instructors[group.instructor_id].name}}</router-link></td>
                </tr>
                </tbody>
            </table>
            </div>
        </b-card>
    </div>
    </div>
</template>
<script>
import Student from '@/components/layouts/student/Student.vue'
import Breadcrumbs from '@/components/Breadcrumbs'

export default {
    name: 'StudentGroups',
    data () {
      return {
        groups: {
          title: '',
          course_id: '',
          instructor_id: '',
          slug: ''
        },
        students: {
          id: ''
        },
        courses: {
          id: '',
          title: ''
        },
        instructors: {
          name: '',
          id: ''
        }
      }
    },
    created () {
      this.$emit('update:layout', Student)
      this.checkSignedIn()
      this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/student/dashboard`)
                .then(response => {
                  this.students = response.data.students
                  // this.groups = response.data.groups
                }) 
      this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/student/groups`)
        .then(response => {
                  // this.students = response.data.students
          this.groups = response.data.groups
          this.courses = response.data.courses.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})   
          this.instructors = response.data.instructors.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })     
        .catch(error => {
          this.setError(error, 'Что-то пошло не так')
        })
    },
  methods: {
      checkSignedIn () {
          if (this.$store.state.signedIn && this.$store.getters.isStudent) {
            this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/student/dashboard`)
            .then(response => {
                if (this.$store.getters.currentUserId === response.data.id) {
                  this.$router.replace('/')
                  return
                }
                this.request = response.data
            })
            .catch(error => { this.setError(error, 'Что-то пошло не так') })
        } else {
            this.$router.replace('/')
        }
      }
  }
}
</script>