<template>
<div class="row">
  <div class="col-md-5 ml-md-5">
    <b-alert  v-if="error" show variant="alert">
      {{ error }}
    </b-alert>
    <b-alert  v-if="notice" v-model="showDismissibleAlert" dismissible variant="success">
      {{ notice }}
    </b-alert>
    <b-card class="card" header = "Изменить курс">
       <table>
          <tr>
            <td class="userInfo"><div style="width:15rem;">Курс</div> </td>
            <td v-show="course !== editedCourse" @dblclick="editCourse(course)" class="userInfo">
              {{ course.title }}</td>
              <td v-show="course === editedCourse"
                v-on:blur="course.editedCourse=false; $emit('update')">
              <input class="form-control" v-if="course === editedCourse" v-click-outside="checkCourse" v-request-focus v-model="course.title" @keyup.enter="checkCourse()"/></td>
          </tr>
         <tr>
            <td class="userInfo">Цена </td>
            <td v-show="course !== editedCoursePrice" @dblclick="editCoursePrice(course)" class="userInfo">
              {{ course.price }}</td>
              <td v-show="course === editedCoursePrice"
                v-on:blur="course.editedCourse=false; $emit('update')">
              <input class="form-control" v-if="course === editedCoursePrice" v-click-outside="checkPrice" v-request-focus v-model="course.price" @keyup.enter="checkPrice()"/></td>
          </tr>
         <tr>
            <td class="userInfo">Slug </td>
            <td v-show="course !== editedCourseSlug" @dblclick="editCourseSlug(course)" class="userInfo">
              {{ course.slug }}</td>
              <td v-show="course === editedCourseSlug"
                v-on:blur="course.editedCourse=false; $emit('update')">
              <input class="form-control" v-if="course === editedCourseSlug" v-click-outside="checkSlug" v-request-focus v-model="course.slug" @keyup.enter="checkSlug()"/></td>
          </tr>
         <tr>
            <td class="userInfo">Уровень </td>
            <td v-show="course !== editedCourseLevel" @dblclick="editCourseLevel(course)" class="userInfo">
              {{ course.level }}</td>
              <td v-show="course === editedCourseLevel"
                v-on:blur="course.editedCourseLevel=false; $emit('update')">
              <input class="form-control" v-if="course === editedCourseLevel" v-click-outside="checkLevel" v-request-focus v-model="course.level" @keyup.enter="checkLevel()"/></td>
          </tr>
         <tr>
            <td class="userInfo">Длительность </td>
            <td v-show="course !== editedCourseDuration" @dblclick="editCourseDuration(course)" class="userInfo">
              {{ course.duration }}</td>
              <td v-show="course === editedCourseDuration"
                v-on:blur="course.editedCourse=false; $emit('update')">
              <input class="form-control" v-if="course === editedCourseDuration" v-click-outside="checkDuration" v-request-focus v-model="course.duration" @keyup.enter="checkDuration()"/></td>
          </tr>
         <tr>
            <td class="userInfo">Доступность </td>
            <td v-show="course !== editedCourseAvailability" @dblclick="editCourseAvailability(course)" class="userInfo">
              {{ course.visible }}</td>
              <td v-show="course === editedCourseAvailability"
                v-on:blur="course.editedCourse=false; $emit('update')">
                  <select class="form-control" v-if="course === editedCourseAvailability" v-click-outside="checkVisible" v-model="course.visible" @keyup.enter="checkVisible()">
              <option value='true'>Available</option>
              <option value='false'>Not available</option>
            </select>
              </td>
          </tr>
       </table>
    <form class="form-app form-edit" @submit.prevent="update">
      <div class="form-group">
        Показывать в курсах:
      </div>
      <div class="form-group">
        <input type="checkbox" id="checkbox" v-model="course.shown"><label for="checkbox">Show</label>
      </div>
      <button type="submit" class="btn btn-primary mb-3" @click="update()">Обновить</button>
      <div>
        <router-link :to="`/admin/course`">Назад к таблице Курсов</router-link>
      </div>
    </form>
    </b-card>
  </div>
  <div class="col-md-6">
    <b-card header="Программа">
      <div class = "table-responsive table-hover mt-3">
      <table class="table first-td-padding table-striped">
        <thead>
          <tr>
            <td>N</td>
            <td>Заголовок</td>
            <td>Описание</td>
            <td>Действия</td>
          </tr>
        </thead>
        <tbody>
          <tr v-for="program in programsList" @dblclick="editProgram(program)">
            <td>{{ program.number }}</td>
            <td><div v-show="program !== editedProgram">
              {{ program.title }}
            </div>
            <div v-show="program === editedProgram"
                v-on:blur="program.editedProgram=false; $emit('update')">
              <input min="11"  v-request-focus v-model="program.title"/>
            </div></td>
            <td><div v-show="program !== editedProgram">
              {{ program.description }}
            </div>
            <div v-show="program === editedProgram"
                v-on:blur="program.editedProgram=false; $emit('update')">
              <input min="11"  v-request-focus v-model="program.description"/>
            </div></td>
            <td>
              <font-awesome-icon class="red" v-show="program !== editedProgram" icon="trash" @click="alertDisplay(program)"/>
              <div v-show="program === editedProgram" @click="updateProgram(editedProgram)">
                <button type="button" class="btn btn-sm btn-warning" name="button">Изменить</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      </div>
      N: <input class="form-control" v-model="program.number">
      Заголовок: <input class="form-control" v-model="program.title">
      Описание: <input class="form-control" v-model="program.description">
      <button class="btn btn-success mt-3" @click="addToProgram(program)">
        add to program
      </button>
    </b-card>
  </div>
</div>
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'

export default {
  name: 'CourseEdit',
  data () {
    return {
      error: '',
      notice: '',
      course: {
        title: '',
        price: '',
        slug: '',
        visible: '',
        duration: '',
        level: ''
      },
      editedProgram: '',
      programs: [],
      program: {
        title: '',
        description: '',
        course_id: '',
        number: ''
      },
      courses: [],
      editedCourse: '',
      editedCoursePrice: '',
      editedCourseSlug: '',
      editedCourseLevel: '',
      editedCourseDuration: '',
      editedCourseAvailability: '',
      resource_url: '/admin/course/:slug',
      showDismissibleAlert: false
    }
  },
  computed: {
    programsList () {
      let prog = []
      for(let i=0;i<this.programs.length;i++) {
        if(this.programs[i].course_id==this.$route.params.id){
          prog.push(this.programs[i])
        }
      }
      return prog
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/${this.$route.params.id}`)
        .then(response => {
          this.course = response.data.course
        })
        .catch(error => { this.setError(error, 'Error') })
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users`)
        .then(response => {
          this.users = response.data.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses`)
        .then(response => {
          this.programs = response.data.program
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
    update () {
      this.editedCourse = ''
      this.editedCourseDuration = ''
      this.editedCourseLevel = ''
      this.editedCoursePrice = ''
      this.editedCourseSlug = ''
      this.editedCourseAvailability = ''
      this.showDismissibleAlert = true
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/${this.$route.params.id}`, this.course)
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateSuccessful (response) {
      this.notice = 'Курс обновлен'
      this.error = ''
    },
    updateFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    checkCourse () {
      if (this.course1.title !== this.editedCourse.title){
        this.update()
      } else {
        this.editedCourse = ''
      }
    },
    checkPrice () {
      if (this.course1.price !== this.editedCoursePrice.price){
        this.update()
      } else {
        this.editedCoursePrice = ''
      }
    },
    checkSlug () {
      if (this.course1.slug !== this.editedCourseSlug.slug){
        this.update()
      } else {
        this.editedCourseSlug = ''
      }
    },
    checkVisible () {
      if (this.course1.visible !== this.editedCourseAvailability.visible){
        this.update()
      } else {
        this.editedCourseAvailability = ''
      }
    },
    checkLevel () {
      if (this.course1.level !== this.editedCourseLevel.level){
        this.update()
      } else {
        this.editedCourseLevel = ''
      }
    },
    checkDuration () {
      if (this.course1.duration !== this.editedCourseDuration.duration){
        this.update()
      } else {
        this.editedCourseDuration = ''
      }
    },
    editCourse (course) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/${this.$route.params.id}`)
        .then(response => {
          this.course1 = response.data.course
          this.editedCourseDuration = ''
          this.editedCourseLevel = ''
          this.editedCoursePrice = ''
          this.editedCourseSlug = ''
          this.editedCourseAvailability = ''
          this.editedCourse = course
        })
    },
    editCoursePrice (course) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/${this.$route.params.id}`)
        .then(response => {
          this.course1 = response.data.course
          this.editedCourse = ''
          this.editedCourseDuration = ''
          this.editedCourseLevel = ''
          this.editedCourseSlug = ''
          this.editedCourseAvailability = ''
          this.editedCoursePrice = course
        })
    },
    editCourseLevel (course) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/${this.$route.params.id}`)
        .then(response => {
          this.course1 = response.data.course
          this.editedCourse = ''
          this.editedCourseDuration = ''
          this.editedCoursePrice = ''
          this.editedCourseSlug = ''
          this.editedCourseAvailability = ''
          this.editedCourseLevel = course
        })
    },
    editCourseDuration (course ) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/${this.$route.params.id}`)
        .then(response => {
          this.course1 = response.data.course
          this.editedCourse = ''
          this.editedCourseLevel = ''
          this.editedCoursePrice = ''
          this.editedCourseSlug = ''
          this.editedCourseAvailability = ''
          this.editedCourseDuration = course
        })
    },
    editCourseSlug (course) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/${this.$route.params.id}`)
        .then(response => {
          this.course1 = response.data.course
          this.editedCourse = ''
          this.editedCourseDuration = ''
          this.editedCourseLevel = ''
          this.editedCoursePrice = ''
          this.editedCourseAvailability = ''
          this.editedCourseSlug = course
        })
    },
    editCourseAvailability (course) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/${this.$route.params.id}`)
        .then(response => {
          this.course1 = response.data.course
          this.editedCourse = ''
          this.editedCourseDuration = ''
          this.editedCourseLevel = ''
          this.editedCoursePrice = ''
          this.editedCourseSlug = ''
          this.editedCourseAvailability = course
        })
    },
    addToProgram (program) {
      program.course_id = this.$route.params.id
      this.showDismissibleAlert = true
      this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/program/new`, program)
        .then(response => this.createSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    editProgram (program) {
      this.editedProgram = program
    },
    createSuccessful (response) {
      this.notice = 'Программа добавлена'
      this.error = ''
    },
    updateProgram (program) {
      this.editedProgram = ''
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/program/${program.id}`, {
        program: {
          title: program.title,
          description: program.description
        }
      })
        .then(response => this.updateProgramSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateProgramSuccessful(response) {
      this.notice = 'Программа изменена'
      this.error = ''
    },
    // showProgramsLink (program) {
    //   return this.$store.getters.isAdmin && this.$store.getters.currentUserId !== program.id
    // },
    removeProgram (program) {
      this.$http.secured.delete(`/${this.$store.getters.getCurrentCity.slug}/admin/program/${program.id}`)
        .then(response => this.programs.splice(this.programs.indexOf(program), 1))
        .catch(error => this.setError(error, 'Невозможно удалить программу'))
      this.notice = 'Успешно удалена ' + program.title
    },
    alertDisplay (program) {
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
          this.$swal('Deleted', 'Вы успешно удалили программу', 'success')
          this.removeProgram(program)
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
  components: { Admin }
}
</script>

<style>
  .userInfo{
    font-size: 1.2rem;
  }
</style>
