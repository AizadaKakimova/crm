<template>
    <div class="groups col-md-10">
      <b-card header = "Группы">
      <b-alert  v-if="error" show dismissible variant="danger">
        {{ error }}
      </b-alert>
      <b-alert  v-if="notice" show dismissible variant="success">
        {{ notice }}
      </b-alert>
      <h4>Группы
      </h4>
      <div class="tabs">
          <div class="d-flex justify-content-end">
            <button class="btn btn-outline-primary mb-3" v-for="(tab, index) in tabs" :class="{active : currentTab === index}" @click="currentTab = index">{{ tab }}</button>
          </div>
      </div>
      <div v-show="currentTab === 0">
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Group</th>
            <th>Start</th>
            <th>End</th>
          </tr>
        </thead>
        <tbody>
                     <tr v-if="groups.length && courses[group.course_id].visible && new Date(group.start) < new Date() &&
            new Date(group.end) > new Date()" v-for="group in filteredGroups" :key="group.id"
              :group="group">
            <td>
              <div>
                <router-link :to="`/instructor/groups/${group.id}`">
                  {{ group.title }}
                </router-link>
              </div>
            </td>
            <td>
              <div>
                {{ group.start | formatDate }}
              </div>
            </td>
            <td>
              <div>
                {{ group.end | formatDate }}
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      </div>
      <div v-show="currentTab === 1">
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Group</th>
            <th>Start</th>
            <th>End</th>
          </tr>
        </thead>
        <tbody>
                     <tr v-if="groups.length && courses[group.course_id].visible && new Date(group.start) < new Date() && 
                     new Date(group.end) < new Date()" v-for="group in filteredGroups" :key="group.id"
              :group="group" >
            <td>
              <div>
                <router-link :to="`/instructor/groups/${group.id}`">
                  {{ group.title }}
                </router-link>
              </div>
            </td>
            <td>
              <div>
                {{ group.start | formatDate }}
              </div>
            </td>
            <td>
              <div>
                {{ group.end | formatDate }}
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      </div>
      <div v-show="currentTab === 2">
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Group</th>
            <th>Start</th>
            <th>End</th>
          </tr>
        </thead>
        <tbody>
            <tr v-if="groups.length && courses[group.course_id].visible && new Date(group.start) > new Date()" 
                v-for="group in filteredGroups" :key="group.id" :group="group" >
            <td>
              <div>
                <router-link :to="`/instructor/groups/${group.id}`">
                  {{ group.title }}
                </router-link>
              </div>
            </td>
            <td>
              <div>
                {{ group.start | formatDate }}
              </div>
            </td>
            <td>
              <div>
                {{ group.end | formatDate }}
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      </div>
        </b-card>
    </div>
</template>
<script>
import Instructor from '@/components/layouts/instructor/Instructor.vue'
import Breadcrumbs from '@/components/Breadcrumbs'

export default {
  name: 'InstructorGroupsList',
  data () {
    return {
      groups: [],
      group_ids: '',
      teaching_hours: '',
      error: '',
      notice: '',
      users: [],
      currentTab: 0,
      startDate: '',
      endDate: '',
      page: 1,
      perPage: 10,
      pages: [],
      courseList: '',
      tabs: ['Активные', 'Прошлые', 'Запланированные'],
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
      search: '',
      courses: []
    }
  },
  created () {
    this.$emit('update:layout', Instructor)
    this.checkSignedIn()
    if (this.$store.state.signedIn && this.$store.getters.isInstructor) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/instructors/${this.$store.state.currentUser.id}`)
            .then(response => {
            this.groups = response.data.groups
            })
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${this.$store.state.currentUser.id}`)
                    .then(response => {
                    this.user = response.data.user
                    })
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses`)
            .then(response => {
            this.courses = response.data.courses.reduce((acc, value) => {
                acc[value.id] = value
                return acc
            }, {})
            })
    }
  },
  computed: {
    filteredGroups () {
      return this.paginate(this.groups.filter((group) => {
        let range = true
        if (this.startDate) {
          range = range && new Date(group.start) >= new Date(this.startDate)
          alert('1')
        }
        if (this.endDate) {
          range = range && new Date(group.end) <= new Date(this.endDate)
          alert('2')
        }
        if (this.courseList) {
          range = range && this.courseList === group.course_id
          alert('3')
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
<style lang="css" scoped>
  .danger  {
    background: orange;
  }
  .success  {
    background: green;
  }
  .warning  {
    background: grey;
  }
  tr {
    font-weight: bold;
  }

</style>
