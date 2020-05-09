<template>
    <div class="row">
  <div class="col-md-3">
    <router-link :to="`/student/groups`">
      <div class="card bg-primary card1">
        <div class="card-body">
          <blockquote class="blockquote my-2 mb-0 text-white">
            <div class="d-flex justify-content-between">
                <span>Группы {{groups.length}}</span>
                <font-awesome-icon icon="users" class="fa-2x ml-3"/>
            </div>
          </blockquote>
        </div>
        </div>
    </router-link>
  </div>
    <div class="col-md-3">
    <router-link  :to="`/student/schedule`">
    <div class="card bg-secondary card1">
      <div class="card-body">
          <blockquote class="blockquote my-2 mb-0 text-white">
            <div class = "d-flex justify-content-between">
              <span>Расписание</span>
              <font-awesome-icon icon="chart-bar" class="fa-2x ml-5"/>
            </div>
          </blockquote>
      </div>
  </div>
    </router-link>
  </div>
  <div class="col-md-3">
    <div class="card bg-danger card1">
      <div class="card-body">
        <blockquote class="blockquote my-2 mb-0 text-white">
          <div class = "d-flex justify-content-between">
            <span>Настройки</span>
            <font-awesome-icon icon="cog" class="fa-2x ml-5"/>
          </div>
        </blockquote>
      </div>
    </div>
  </div>
</div>
</template>
<script>
import Student from '@/components/layouts/student/Student.vue'
import Breadcrumbs from '@/components/Breadcrumbs'

export default {
  name: 'StudentDashboard',
  data () {
    return {
      students: {
        id: ''
      },
      groups: {}
    }
  },
  created () {
      this.$emit('update:layout', Student)
      this.checkSignedIn()
      if (this.$store.state.signedIn && this.$store.getters.isStudent) {
      this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/student/dashboard`)
        .then(response => {
          this.students = response.data.students
          this.groups = response.data.groups
        })
    }
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
