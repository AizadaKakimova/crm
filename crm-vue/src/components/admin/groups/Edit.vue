<template>
    <div>
      <b-alert  v-if="error" show dismissible ariant="alert">
        {{ error }}
      </b-alert>
      <b-alert  v-if="notice" v-model="showDismissibleAlert" dismissible variant="success">
        {{ notice }}
      </b-alert>
      <div class="row">
      <div class="col-md-5 ml-3">
      <b-card header = "Edit" class = "card">
        <table>
          <tr>
            <td>Название </td>
            <td v-show="group !== editedGroup" @dblclick="editGroup(group)" class="userInfo">
              {{ group.title }}</td>
              <td v-show="group === editedGroup"
                v-on:blur="group.editedGroup=false; $emit('update')">
              <input class="form-control" v-if="group === editedGroup" v-click-outside="checkGroup" v-request-focus v-model="group.title" @keyup.enter="checkUser()"/></td>
          </tr>
          <tr>
            <td>Преподаватель </td>
            <td v-show="group !== editedGroupInstructor" @dblclick="editGroupInstructor(group)" class="userInfo" v-if="group.instructor_id">
              {{ teacher.name }}</td>
            <td v-show="group === editedGroupInstructor" v-on:blur="group.editedGroup=false; $emit('update')">
              <select class="form-control" v-if="group === editedGroupInstructor" v-click-outside="updateGroup" v-model="group.instructor_id">
            <option v-for="instructor in instructors" v-bind:value="instructor.id" v-bind:key="instructor.id">{{ instructor.name }}</option>
          </select></td>
          </tr> 
          <tr>
            <td>Курс </td>
            <td v-show="group !== editedGroupCourse" @dblclick="editGroupCourse(group)" class="userInfo" v-if="group.course_id">
              {{courses[group.course_id].title}}
            </td>
            <td v-show="group === editedGroupCourse" v-if="group.course_id" >
              <select class="form-control" v-if="group === editedGroupCourse" v-click-outside="updateGroup" v-model="group.course_id" placeholder="group.course_id">
            <option v-if="course.visible" v-for="course in courses"  v-bind:value="course.id" v-bind:key="course.id">{{ course.title }}</option>
          </select></td>
          </tr>
          <tr>
            <td>Начало </td>
             <td v-show="group !== editedGroupStart" @dblclick="editGroupStart(group)" class="userInfo">
               {{group.start | formatDate}}
             </td>
            <td v-show="group === editedGroupStart"> <datepicker v-if="group === editedGroupStart" @keyup.enter="checkStart()" v-click-outside="checkStart" v-model="group.start" name="start">{{ group.start | formatDate }}</datepicker> </td>
          </tr>
          <tr>
            <td>Конец </td>
            <td v-show="group !== editedGroupEnd" @dblclick="editGroupEnd(group)" class="userInfo">
               {{group.end | formatDate}}
             </td>
            <td v-show="group === editedGroupEnd"><datepicker v-if="group === editedGroupEnd" @keyup.enter="checkEnd()" v-click-outside="checkEnd" v-model="group.end" name="end">{{ group.end | formatDate }}</datepicker></td>
          </tr>
        </table>
        <button type="submit" class="btn btn-primary mb-3" @click="updateGroup()">Обновить</button>
        <div>
          <router-link to="/admin/groups">Назад к таблице Групп</router-link>
        </div>
      </b-card>
      </div>
        <div class="col-md-5 ml-3">
    <b-card header="Время занятий">
      <div class="tabs">
        <div class="d-flex justify-content-start">
          <button class="btn btn-outline-primary mb-3" v-for="(item, index) in days" :class="{active : currentTab === index}" @click="currentTab = index">{{item.title}}</button>
        </div>
      </div>
      <div class="tab-content">
        <div v-show="currentTab === 0">
          <ul>
            <li v-for="time in times"><input type="radio" v-model="selected" :value="time.item">{{time.item}}</li>
          </ul>
          <button  type="submit" class="btn btn-primary mb-3" @click="addToSchedule(group)">Добавить</button>
        </div>
      </div>
      <div class="tab-content">
        <div v-show="currentTab === 1">
          <ul>
            <li v-for="time in times"><input type="radio" v-model="selected" :value="time.item">{{time.item}}</li>
          </ul>
          <button  type="submit" class="btn btn-primary mb-3" @click="addToSchedule(group)">Добавить</button>
        </div>
      </div>
      <div class="tab-content">
        <div v-show="currentTab === 2">
          <ul>
            <li v-for="time in times"><input type="radio" v-model="selected" :value="time.item">{{time.item}}</li>
          </ul>
          <button  type="submit" class="btn btn-primary mb-3" @click="addToSchedule(group)">Добавить</button>
        </div>
      </div>
      <div class="tab-content">
        <div v-show="currentTab === 3">
          <ul>
            <li v-for="time in times"><input type="radio" v-model="selected" :value="time.item">{{time.item}}</li>
          </ul>
          <button  type="submit" class="btn btn-primary mb-3" @click="addToSchedule(group)">Добавить</button>
        </div>
      </div>
      <div class="tab-content">
        <div v-show="currentTab === 4">
          <ul>
            <li v-for="time in times"><input type="radio" v-model="selected" :value="time.item">{{time.item}}</li>
          </ul>
          <button  type="submit" class="btn btn-primary mb-3" @click="addToSchedule(group)">Добавить</button>
        </div>
      </div>
      <div class="tab-content">
        <div v-show="currentTab === 5">
          <ul>
            <li v-for="time in times"><input type="radio" v-model="selected" :value="time.item">{{time.item}}</li>
          </ul>
          <button  type="submit" class="btn btn-primary mb-3" @click="addToSchedule(group)">Добавить</button>
        </div>
      </div>
      <div class="tab-content">
        <div v-show="currentTab === 6">
          <ul>
            <li v-for="time in times"><input type="radio" v-model="selected" :value="time.item">{{time.item}}</li>
          </ul>
          <button  type="submit" class="btn btn-primary mb-3" @click="addToSchedule(group)">Добавить</button>
        </div>
      </div>
    </b-card>
  </div>
      </div>
    </div>
    
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'
import Datepicker from 'vuejs-datepicker'
import VueTimepicker from 'vue2-timepicker'


export default {
  name: 'GroupEdit',
  data () {
    return {
      error: '',
      notice: '',
      users: {},
      title: '',
      selected: [],
      currentTab: 0,
      days: [
        { id: 0,
          title: 'Mon'},
        { id:1,
          title: 'Tue'},
        { id:2,
          title: 'Wed'},
        { id:3,
          title: 'Thu'},
        { id:4,
          title: 'Fri'},
        { id:5,
          title: 'Sat'},
        { id:6,
          title: 'Sun'},
      ],
      times: [
        {item: '10:00-12:00'},
        {item: '12:00-14:00'},
        {item: '14:00-16:00'},
        {item: '16:00-18:00'},
        {item: '18:00-20:00'}
      ],
      group: {
        title: '',
        start: '',
        end: '',
        time: []
      },
      instructors: [],
      courses: [],
      editedGroup: '',
      editedGroupInstructor: '',
      editedGroupCourse: '',
      editedGroupStart: '',
      editedGroupEnd: '',
      resource_url: ':currentCity/admin/groups/:slug',
      showDismissibleAlert: false
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/groups/${this.$route.params.slug}`)
        .then(response => {
          this.group = response.data.group
          this.enrollments_enrolled = response.data.enrollments_enrolled
          this.enrollments_dropped = response.data.enrollments_dropped
          this.teacher = response.data.instructor
        })
        .catch(error => { this.setError(error, 'Error') })
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users`)
        .then(response => {
          this.users = response.data.users.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users/instructors`)
        .then(response => { this.instructors = response.data })
        .catch(error => { this.setError(error, 'Что-то пошло не так') })
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses`)
        .then(response => {
          this.courses = response.data.courses.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    updateGroup (group) {
      this.editedGroup = ''
      this.editedGroupInstructor = ''
      this.editedGroupCourse = ''
      this.editedGroupEnd = ''
      this.editedGroupStart = ''
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/groups/${this.$route.params.slug}`, this.group)
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateSuccessful (response) {
      this.notice = 'Группа обновлена'
      this.error = ''
    },
    updateFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    updateResource (data) {
      this.groups = data
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    checkGroup () {
      if (this.group1.title !== this.editedGroup.title) {
        this.updateGroup()
      }
      else {
        this.editedGroup = ''
      }
    },
    checkStart () {
      if (this.group1.start !== this.editedGroupStart.start){
        this.updateGroup()
      }
      else {
        this.editedGroupStart = ''
      }
    },
    checkEnd () {
      if (this.group1.end !== this.editedGroupEnd.end){
        this.updateGroup()
      }
      else {
        this.editedGroupEnd= ''
      }
    },
    editGroup (group) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/groups/${this.$route.params.slug}`)
        .then(response => {
          this.group1 = response.data.group
          this.editedGroupInstructor = ''
          this.editedGroupCourse = ''
          this.editedGroupEnd = ''
          this.editedGroupStart = ''
          this.editedGroup = group
        })
    },
    editGroupCourse (group) {
      this.editedGroupInstructor = ''
      this.editedGroup = ''
      this.editedGroupEnd = ''
      this.editedGroupStart = ''
      this.editedGroupCourse = group

    },
    editGroupInstructor (group) {
      this.editedGroup = ''
      this.editedGroupCourse = ''
      this.editedGroupEnd = ''
      this.editedGroupStart = ''
      this.editedGroupInstructor = group

    },
    editGroupStart (group) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/groups/${this.$route.params.slug}`)
        .then(response => {
          this.group1 = response.data.group
          this.editedGroup = ''
          this.editedGroupCourse = ''
          this.editedGroupInstructor = ''
          this.editedGroupEnd = ''
          this.editedGroupStart = group
        })
    },
    editGroupEnd (group) {
      this.$http.secured.get(`//${this.$store.getters.getCurrentCity.slug}admin/groups/${this.$route.params.slug}`)
        .then(response => {
          this.group1 = response.data.group
          this.editedGroup = ''
          this.editedGroupCourse = ''
          this.editedGroupInstructor = ''
          this.editedGroupStart = ''
          this.editedGroupEnd = group
        })
    },
    addToSchedule (group) {
      for(let i=0; i<this.selected.length; i++){
        group.time.push(this.selected)
      }
      for(let i=0; i<this.days.length; i++){
        if(this.currentTab===this.days[i].id){
          group.day.push(this.days[i].title)
        }
      }
      this.selected = ''
      this.showDismissibleAlert = true
      this.$http.secured.patch(`${this.$store.getters.getCurrentCity.slug}/admin/groups/${this.$route.params.slug}`, this.group)
        .then(response => this.updateTimeSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateTimeSuccessful (response) {
      this.notice = 'Время добавлено'
      this.error = ''
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
          this.$swal('Deleted', 'Вы успешно удалили группу', 'success')
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
    },
    'click-outside': {
        bind: function (el, binding, vNode) {
          // Provided expression must evaluate to a function.
          if (typeof binding.value !== 'function') {
            const compName = vNode.context.name
            let warn = `[Vue-click-outside:] provided expression '${binding.expression}' is not a function, but has to be`
            if (compName) {
              warn += `Found in component '${compName}'`
            }

            console.warn(warn)
          }
          // Define Handler and cache it on the element
          const bubble = binding.modifiers.bubble
          const handler = (e) => {
            if (bubble || (!el.contains(e.target) && el !== e.target)) {
              binding.value(e)
            }
          }
          el.__vueClickOutside__ = handler

          // add Event Listeners
          document.addEventListener('click', handler)
        },

        unbind: function (el, binding) {
          // Remove Event Listeners
          document.removeEventListener('click', el.__vueClickOutside__)
          el.__vueClickOutside__ = null

        }
      }
  },
  components: { Admin, Datepicker }
}
</script>
<style scoped>
li {
  display: inline-block;
  margin-right: 1.8rem;
}

/* .collapse, #monday,
#tue, #wed, #thu, #fri {
  font-size: 0.75rem;
} */
</style>