<template>
<div class="row">
  <div class="col-md-3" v-if="groups.length">
    <router-link :to="`/instructor/${user.id}/groups`">
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
  <div class="col-md-3">
    <router-link  :to="`/instructor/hours/${user.id}`">
    <div class="card bg-secondary card1">
      <div class="card-body">
          <blockquote class="blockquote my-2 mb-0 text-white">
            <div class = "d-flex justify-content-between">
              <span>Часы {{teaching_hours}} | {{teaching_hours_individs}}</span>
              <font-awesome-icon icon="chart-bar" class="fa-2x ml-5"/>
            </div>
          </blockquote>
      </div>
  </div>
    </router-link>
  </div>
</div>

</template>
<script>
import Instructor from '@/components/layouts/instructor/Instructor.vue'
import Breadcrumbs from '@/components/Breadcrumbs'

export default {
  name: 'InstructorDash',
  data () {
    return {
      groups: [],
      group_ids: '',
      teaching_hours: '',
      teaching_hours_individs: '',
      users: [],
      group: {
        title: '',
        course_id: '',
        instructor_id: '',
        start: '',
        end: ''
      },
      user: {
        phone: '',
        name: '',
        email: ''
      },
      search: ''
    }
  },
  created () {
    this.$emit('update:layout', Instructor)
    this.checkSignedIn()
    if (this.$store.state.signedIn && this.$store.getters.isInstructor) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/instructors/${this.$store.state.currentUser.id}`)
        .then(response => {
          this.groups = response.data.groups
          this.teaching_hours = response.data.teaching_hours
          this.teaching_hours_individs = response.data.teaching_hours_individs
        })
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$store.state.currentUser.id}`)
                .then(response => {
                  this.user = response.data.user
                })
    }
  },
  computed: {
    filteredGroups () {
      return this.paginate(this.groups.filter((group) => {
        let range = true
        if (this.startDate) {
          range = range && new Date(group.start) >= new Date(this.startDate)
        }
        if (this.endDate) {
          range = range && new Date(group.end) <= new Date(this.endDate)
        }
        if (this.courseList) {
          range = range && this.courseList === group.course_id
        }
        return range && group.title.toLowerCase().match(this.search)
      }))
    }
  },
  methods: {
    paginate (groups) {
      let page = this.page
      let perPage = this.perPage
      let from = (page * perPage) - perPage
      let to = (page * perPage)
      return groups.slice(from, to)
    },
    checkSignedIn () {
      if (this.$store.state.signedIn && this.$store.getters.isInstructor) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/instructor/dashboard`)
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
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
      this.notice = ''
    }
  },
  components: { Instructor, Breadcrumbs }
}
</script>

<style scoped>
.card1{
  border-radius: 0!important;
  box-shadow: 2px 2px grey;
}
span{
  font-size: 1.2rem;
  color: #F8F8FF;
}
.fa-2x{
  filter: opacity(50%);
}
.span2{
  filter: opacity(50%);
}
.card1:hover{
  filter: opacity(0.9);
  box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
}
a:hover{
  text-decoration: none!important;
}
</style>
