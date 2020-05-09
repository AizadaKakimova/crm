<template>
<div>
<div class = "row">
<div class = "col-xs-12 col-md-12">
  <b-card header= "Таблица групп" class = "card">
    <b-alert class="col-4 alert-danger" v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert  v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <div class="groups col-md-3">
      <router-link to="/admin/groups/new">
          <button class="btn btn-primary">
            <font-awesome-icon icon="plus-square"/> Добавить группу
          </button>
      </router-link>
      <br/><br/>
      <button class="btn btn-primary mb-3" data-toggle="collapse" data-target="#show1">
         Показать/Скрыть фильтры
      </button>
    </div>
    <div class="col-md-4">
      <form id="show1" class="collapse">
          <div class="form-group w-100">
            <input type="text" v-model="search" placeholder="Поиск"  aria-label="Search" class="form-control mr-sm-2 w-100" id="input-icon-left" name="input-icon-left" @keyup="doFilter()"required/>
            <select name="course" v-model="courseList" class="form-control w-100 my-3">
              <option disabled selected style="display:none" v-bind:value="course.id" :key="course.id">
                Выбрать курс
              </option>
              <option v-if="course.visible" v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">
                {{ course.title }}
              </option>
            </select>
            <div class ="d-flex">
              <datepicker v-model="group.start" name="start" placeholder="Дата начала" id="date"></datepicker>
            <div class="form-inline">
              <datepicker v-model="group.end" placeholder="Дата окончания" name="end" id="date2" class="ml-5"></datepicker>
            </div>
          </div>
          <div class="form-group mt-3">
           <input class="btn btn-danger" type="reset" @click="reset()"/>
          </div>
          </div>
      </form>
      </div>
      <div class="groups col-md-9" @click="updateGroup(editedGroup)">
      </div>

      <div class="tabs">
          <div class="d-flex justify-content-end">
            <button class="btn btn-outline-primary mb-3" v-for="(tab, index) in tabs" :class="{active : currentTab === index}" @click="currentTab = index">{{ tab }}</button>
          </div>
      </div>

    <div class = "table-responsive table-hover table-striped">
    <div class="tab-content">
      <div v-show="currentTab === 0">
        <table class="table first-td-padding">
          <thead>
          <tr>
            <th>ID</th>
            <th>Название</th>
            <th>Курс</th>
            <th>Преподаватель</th>
            <th>Человек</th>
            <th>Начало</th>
            <th>Конец</th>
          </tr>
          </thead>
          <tbody>
          <tr v-if="groups.length && courses[group.course_id].visible && new Date(group.start) < new Date() &&
            new Date(group.end) > new Date()" v-for="group in filteredGroups" :key="group.id"
              :group="group" @dblclick="editGroup(group)">
            <td>
              {{ group.id }}
            </td>
            <td width = "70px">
              <div v-show="group !== editedGroup">
                <router-link :to="`/admin/groups/${group.slug}`">
                  {{ group.title }}
                </router-link>
              </div>
              <div class="form-group" v-show="group === editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <input v-model.lazy="group.title" class="form-control">
              </div>
            </td>
            <td>
              <div v-show="group !== editedGroup">
                {{ courses[group.course_id].title }}
              </div>
              <div class="form-group" v-show="group === editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <select v-model="group.course_id" class="form-control">
                  <option v-if="course.visible" v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">
                    {{course.title }}
                  </option>
                </select>
              </div>
            </td>
            <td>
              <div v-show="group !== editedGroup">
                {{ instructors[group.instructor_id].name }}
              </div>
              <div class="form-group" v-show="group === editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <select v-model="group.instructor_id" class="form-control">
                  <option v-for="instructor in instructors" v-bind:value="instructor.id" v-bind:key="instructor.id">
                    {{instructor.name }}
                  </option>
                </select>
              </div>
            </td>
            <td>
              {{ enrollments[group.slug] }}
            </td>
            <td>
              <div v-show="group !==editedGroup">
                {{ group.start | formatDate }}
              </div>
              <div class="form-group" v-show="group === editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <datepicker
                  v-model.lazy="group.start">
                </datepicker>
              </div>
            </td>
            <td>
              <div v-show="group !== editedGroup">
                {{ group.end | formatDate }}
              </div>
              <div class="form-group" v-show="group === editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <datepicker
                  @keyup.enter="updateGroup(group)" v-model.lazy="group.end">
                </datepicker>
              </div>
            </td>
            <td v-if="showGroupLink()">
              <div v-show="group === editedGroup" @click="updateGroup(group)">
              <button type="button" class="btn btn-sm btn-warning" name="button">Изменить</button>
            </div>
            </td>

          </tr>
          </tbody>
        </table>
      </div>
      <div v-show="currentTab === 1">
        <table class="table first-td-padding table-striped">
          <thead>
          <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Course</th>
            <th>Instructor</th>
            <th>Человек</th>
            <th>Начало</th>
            <th>Конец</th>
          </tr>
          </thead>
          <tbody>
          <tr v-if="groups.length && courses[group.course_id].visible && new Date(group.start) < new Date() && new Date(group.end) < new Date()" v-for="group in filteredGroups" :key="group.id"
              :group="group" @dblclick="editGroup(group)">
            <td>
              {{ group.id }}
            </td>
            <td>
              <div v-show="group != editedGroup">
                <router-link :to="`/admin/groups/${group.slug}`">
                  {{ group.title }}
                </router-link>
              </div>
              <div class="form-group" v-show="group == editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <input v-model.lazy="group.title" class="form-control">
              </div>
            </td>
            <td>
              <div v-show="group !== editedGroup">
                {{ courses[group.course_id].title }}
              </div>
              <div class="form-group" v-show="group === editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <select v-model="group.course_id" class="form-control">
                  <option v-if="course.visible" v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">{{
                    course.title }}
                  </option>
                </select>
              </div>
            </td>
            <td>
              
               <div v-show="group !== editedGroup">
                {{ instructors[group.instructor_id].name }}
              </div>              
              <div class="form-group" v-show="group === editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <select v-model="group.instructor_id" class="form-control">
                  <option v-for="instructor in instructors" v-bind:value="instructor.id" v-bind:key="instructor.id">{{
                    instructor.name }}
                  </option>
                </select>
              </div>
            </td>
            <td>
              {{ enrollments[group.slug] }}
            </td>
            <td>
              <div v-show="group !== editedGroup">
                {{ group.start | formatDate }}
              </div>
              <div class="form-group" v-show="group === editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <datepicker
                  v-model.lazy="group.start">
                </datepicker>
              </div>
            </td>
            <td>
              <div v-show="group !== editedGroup">
                {{ group.end | formatDate }}
              </div>
              <div class="form-group" v-show="group === editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <datepicker
                  @keyup.enter="updateGroup(group)" v-model.lazy="group.end">
                </datepicker>
              </div>
            </td>
            <td v-if="showGroupLink()">
              <div v-show="group === editedGroup" @click="updateGroup(group)">
              <button type="button" class="btn btn-sm btn-warning" name="button">Изменить</button>
            </div>
            </td>
          </tr>
          </tbody>
        </table>
      </div>
      <div v-show="currentTab === 2">
        <table class="table first-td-padding table-striped">
          <thead>
          <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Course</th>
            <th>Instructor</th>
            <th>Человек</th>
            <th>Начало</th>
            <th>Конец</th>
          </tr>
          </thead>
          <tbody>
          <tr v-if="groups.length && courses[group.course_id].visible && new Date(group.start) > new Date()" v-for="group in filteredGroups" :key="group.id"
              :group="group" @dblclick="editGroup(group)">
            <td>
              {{ group.id }}
            </td>
            <td>
              <div v-show="group !== editedGroup">
                <router-link :to="`/admin/groups/${group.slug}`">
                  {{ group.title }}
                </router-link>
              </div>
              <div class="form-group" v-show="group === editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <input v-model.lazy="group.title" class="form-control">
              </div>
            </td>
            <td>
              <div v-show="group !== editedGroup">
                {{ courses[group.course_id].title }}
              </div>
              <div class="form-group" v-show="group === editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <select v-model="group.course_id" class="form-control">
                  <option v-if="course.visible" v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">{{                    course.title }}
                  </option>
                </select>
              </div>
            </td>
            <td>
              <div v-show="group !== editedGroup">
                {{ instructors[group.instructor_id].name }}
              </div>
              <div class="form-group" v-show="group === editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <select v-model="group.instructor_id" class="form-control">
                  <option v-for="instructor in instructors" v-bind:value="instructor.id" v-bind:key="instructor.id">{{instructor.name }}
                  </option>
                </select>
              </div>
            </td>
            <td>
              {{ enrollments[group.slug] }}
            </td>
            <td>
              <div v-show="group != editedGroup">
                {{ group.start | formatDate }}
              </div>
              <div class="form-group" v-show="group == editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <datepicker
                  v-model.lazy="group.start">
                </datepicker>
              </div>
            </td>
            <td>
              <div v-show="group != editedGroup">
                {{ group.end | formatDate }}
              </div>
              <div class="form-group" v-show="group == editedGroup"
                   v-on:blur="group.editedGroup=false; $emit('update')">
                <datepicker
                  @keyup.enter="updateGroup(group)" v-model.lazy="group.end">
                </datepicker>
              </div>
            </td>
            <td v-if="showGroupLink()">
              <div v-show="group === editedGroup" @click="updateGroup(editedGroup)">
              <button type="button" class="btn btn-sm btn-warning" name="button">Изменить</button>
            </div>
            </td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>
    </div>
    <div>
      <div class="clearfix btn-group col-md-2 offset-md-5">
        <button type="button" class="btn btn-sm btn-outline-secondary" v-if="page != 1" @click="page--">Назад</button>
        <button type="button" class="btn btn-sm btn-outline-secondary" v-for="pageNumber in pages.slice(page-1, page+5)" @click="page = pageNumber" :key="pageNumber"> {{pageNumber}} </button>
        <button type="button" @click="page++" v-if="page < pages.length" class="btn btn-sm btn-outline-secondary">
          Вперед
        </button>
      </div>
    </div>
    <div class="col-md-12" @click="updateGroup(editedGroup)" style="height: 21%"></div>
    </b-card>
  </div>
</div>
</div>
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'GroupList',
  data () {
    return {
      error: '',
      notice: '',
      show: false,
      search: '',
      courseList: '',
      startDate: '',
      endDate: '',
      page: 1,
      currentTab: 0,
      tabs: ['Активные', 'Прошлые', 'Запланированные'],
      perPage: 10,
      pages: [],
      users: {},
      instructor: {
        name: ''
      },
      course: {
        title: ''
      },
      group: {
        title: '',
        course_id: '',
        instructor_id: '',
        start: '',
        end: ''
      },
      groups: [],
      courses: [],
      enrollments: {},
      editedGroup: ''
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
  created () {
    this.$emit('update:layout', Admin)
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/groups`)
        .then(response => {
          this.groups = response.data.groups
          this.enrollments = response.data.enrollments
          this.instructors = response.data.instructors.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
        .catch(error => {
          this.setError(error, 'Что-то пошло не так')
        })
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
  watch: {
    groups () {
      this.setPages()
    }
  },
  methods: {
    updateResource (data) {
      this.groups = data
    },
    reset () {
      this.search = ''
      this.courseList = ''
      this.startDate = ''
      this.endDate = ''
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    showGroupLink () {
      return this.$store.getters.isAdmin || this.$store.getters.isManager
    },
    removeGroup (group) {
      this.$http.secured.delete(`/${this.$store.getters.getCurrentCity.slug}/admin/groups/${group.id}`)
        .then(response => this.groups.splice(this.groups.indexOf(group), 1))
        .catch(error => this.setError(error, 'Невозможно удалить группу'))
    },
    editGroup (group) {
      this.editedGroup = group
    },
    updateGroup (group) {
      if(this.editedGroup){
        this.editedGroup = ''
        this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/groups/${group.id}`, group)
          .then(response => this.updateSuccessful(response))
          .catch(error => this.updateFailed(error))
      } else {
        this.notice = ''
        this.error = ''
      }
    },
    dateSort (a, b) {
      let date1 = new Date(a.registered).getTime()
      let date2 = new Date(b.registered).getTime()
      return date1 - date2
    },
    updateSuccessful (response) {
      this.notice = 'Группа обновлена'
      this.error = ''
    },
    updateFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    setPages () {
      let numberOfPages = Math.ceil(this.groups.length / this.perPage)
      for (let index = 1; index <= numberOfPages; index++) {
        this.pages.push(index)
      }
    },
    paginate (groups) {
      let page = this.page
      let perPage = this.perPage
      let from = (page * perPage) - perPage
      let to = (page * perPage)
      return groups.slice(from, to)
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
          this.removeGroup(group)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  components: {Admin, Datepicker}
}
</script>
<style lang="css">
button.active{
  background-color: grey;
}
</style>
