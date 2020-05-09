<template>
    <div class="groups col-md-10">
      <b-card header = "Группы">
      <b-alert  v-if="error" show dismissible variant="danger">
        {{ error }}
      </b-alert>
      <b-alert  v-if="notice" show dismissible variant="success">
        {{ notice }}
      </b-alert>
      <h4>Группа {{ group.title }}
      </h4>
        <p><font-awesome-icon icon="book" style="width: 2rem" class="iconsGroup"/> {{ course_title }}</p>
        <p><font-awesome-icon icon="chalkboard-teacher" style="width: 2rem" class="iconsGroup"/>{{ instructor.name }}</p>
        <p><font-awesome-icon :icon="['fas', 'calendar-alt']" style="width: 2rem" class="iconsGroup"/>{{ group.start | formatDate }} до {{ group.end | formatDate }}</p>
        <!-- <button class="btn btn-primary">Загрузить материалы</button> -->
        <!-- <input type="file" @change="onFileChange"> -->
        <!-- <router-link class="btn btn-primary" :to="`/instructor/groups/${this.$route.params.id}/lectures`">Дополнительные материалы</router-link> -->
      <table class="table">
        <thead>
          <tr>
            <th>Имя</th>
            <th>Телефон</th>
            <th>Почта</th>
            <th>Посещения</th>
            <th>Посещеямость</th>
            <th>M коины</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="!loading" v-for="(enrollment, index) in enrollments_enrolled" :key='enrollment.id' :request="enrollment" v-bind:class="{warning:enrollment.status == 'dropped',danger:enrollment.status == 'skipped'}">
              <td id="index">
                <router-link  :to="`/instructor/groups/attendance/${enrollment.id}`">
                  {{ students[enrollment.user_id].name }}
                </router-link>
              </td>
              <td>
                {{ students[enrollment.user_id].phone }}
              </td>
              <td>
                {{ students[enrollment.user_id].email }}
              </td>
              <td v-if="attendance[enrollment.id]">{{ attendance[enrollment.id].length }}</td>
              <td v-else>0</td>
              <td @click="addAttendance(enrollment.id,date,students[enrollment.user_id].name)">
                <font-awesome-icon v-if ="attend.enrollment_id!==enrollment.id" :icon="['fas', 'user']" style="width: 2rem" />
                <font-awesome-icon v-if ="attend.enrollment_id===enrollment.id" :icon="['fas', 'user-check']" style="width: 2rem; color:green;" />
              </td>
              <td><strong> {{ Number(enrollment.coins)}}</strong>
                <button class="coinButton" id="one" @click="addCoins(1, enrollment.id,index, students[enrollment.user_id].name)">1</button>
                <button class="coinButton" id="five" @click="addCoins(5, enrollment.id,index, students[enrollment.user_id].name)">5</button>
                <button class="coinButton" @click="addCoins(10, enrollment.id,index, students[enrollment.user_id].name)">10</button>
                <!-- <input width="10" type="number" v-model="coins[index]">
                <button type="button" name="button" class="btn btn-sm btn-success" @click="addCoins(enrollment.id,index, students[enrollment.user_id].name)">+</button> -->
              </td>
          </tr>
        </tbody>
      </table>
        </b-card>
    </div>
</template>
<script>
import Instructor from '@/components/layouts/instructor/Instructor.vue'
export default {
  name: 'InstructorGroupShow',
  data () {
    return {
      error: '',
      notice: '',
      users: {},
      loading: true,
      date: new Date(),
      title: '',
      coins: [],
      attendance: [],
      instructor: '',
      course_title: '',
      students: {},
      group: {
        title: ''
      },
      enrollments: '',
      enrollments_enrolled: {
        status: ''
      },
      groups: [],
      attend: {
        day: '',
        enrollment_id: ''
      },
      image: ''
    }
  },
  watch: {
    '$route': 'getGroup'
  },
  created () {
    this.$emit('update:layout', Instructor)
    this.getGroup()
  },
  methods: {
    getGroup () {
      if (this.$store.state.signedIn && this.$store.getters.isInstructor) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/instructor/groups/${this.$route.params.id}`)
          .then(response => {
            this.group = response.data.group
            this.instructor = response.data.instructor
            this.course_title = response.data.course_title
            this.enrollments_enrolled = response.data.enrollments_enrolled
            this.attendance = response.data.attendance
            this.students = response.data.students.reduce((acc, value) => {
              acc[value.id] = value
              return acc
            }, {})
            this.loading = false
          })
          .catch(error => { this.setError(error, 'Error') })
      } else {
        this.$router.replace('/')
      }
    },
    addCoins (button, enrollmentId, index, name) {
      if(button === 1){
        this.coins[index] = 1
      } else if (button === 5){
        this.coins[index] = 5
      } else if (button === 10){
        this.coins[index] = 10
      }
      this.$http.secured.put(`/${this.$store.getters.getCurrentCity.slug}/instructor/groups/coins/add?enrollment_id=${enrollmentId}&coins=${this.coins[index]}`)
        .then(response => {
          this.createSuccessful(response, name, this.coins[index])
          this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/instructor/groups/${this.$route.params.slug}`)
            .then(response => {
              this.group = response.data.group
              this.enrollments_enrolled = response.data.enrollments_enrolled
              this.coins = []
            })
        })
        .catch(error => { this.setError(error, 'Коины не добавились!') })
    },
    addAttendance (enrollmentId, day, name) {
      this.attend.enrollment_id = enrollmentId
      this.attend.day = day
      this.$http.secured.put(`/${this.$store.getters.getCurrentCity.slug}/instructor/attendance/new`, this.attend)
        .then(response => {
          this.createAttendSuccessful(response, name)
          this.getGroup()
        })
        .catch(error => { this.setError(error, 'Не проверено!') })
    },
    updateResource (data) {
      this.groups = data
    },
    setError (error, text, index) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createAttendSuccessful (response, name) {
      this.error = ''
    },
    createSuccessful (response, name, coins) {
      this.notice = name + ' ты получил ' + coins + ' коинов!'
      this.error = ''
    },
    editEnrollment (enrollment) {
      this.editedEnrollment = enrollment
    },
    onFileChange(e) {
      var files = e.target.files || e.dataTransfer.files;
      if (!files.length)
        return
      this.createImage(files[0])
    },
    createImage(file) {
      var image = new Image()
      var reader = new FileReader()
      var vm = this
      reader.onload = (e) => {
        vm.image = e.target.result
      }
      reader.readAsDataURL(file)
    },
    removeImage: function (e) {
      this.image = ''
    }
  },
  components: { Instructor }
}
</script>
<style lang="css" scoped>
.coinButton {
  width: 1.8rem;
  height: 1.8rem;
  border-radius: 50%;
  font-size: 0.8rem;
  background: #FFD700;
}
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
  #one{
    width: 1.2rem;
    height: 1.2rem;
    font-size: 0.6rem;
  }
  #five {
    width: 1.6rem;
    height: 1.6rem;
    font-size: 0.7rem;
  }
</style>
