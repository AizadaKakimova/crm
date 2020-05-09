<template>
<div class="groups col-md-10">
  <b-alert v-if="error" show dismissible ariant="alert">
    {{ error }}
  </b-alert>
  <b-alert v-if="notice" show dismissible ariant="success">
    {{ notice }}
  </b-alert>
  <div class="row">
    <div class="groups col-md-3">
      <h3>Groups
        <router-link :to="`/manager/groups/new`">
          <span class="pull-right"><i class="far fa-plus-square"></i></span>
        </router-link>
      </h3>
      <button class="btn btn-primary mb-3" v-on:click="show = !show">Show/Hide filters</button>
      <br /><br />
      <form id="myForm" v-if="show">
        <input type="text" v-model="search" class="form-group" placeholder="search group" />
        <br />
        <h5>Course filter: </h5>
        <div class="form-groupp">
          <select name="course" v-model="courseList" class="form-control">
            <option disabled selected style="display:none" v-bind:value="course.id" :key="course.id">
              Select a course
            </option>
            <option v-if="course.visible" v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">
              {{ course.title }}
            </option>
          </select>
        </div>
        <br />
        <h5>Date range filter:</h5>
        <div class="form-group">
          <datepicker v-model="startDate" name="start" placeholder="Choose start date"></datepicker>
        </div>
        <div class="form-group">
          <datepicker v-model="endDate" name="end" placeholder="Choose end date"></datepicker>
        </div>
        <div class="form-group">
          <input class="btn btn-danger" type="reset" @click="reset()" />
        </div>
      </form>
    </div>
    <div class="groups col-md-9" @click="updateGroup(editedGroup)">
    </div>
  </div>
  <div class="tabs">
    <button v-for="(tab, index) in tabs"
            :class="{active : currentTab === index}"
            @click="currentTab = index"
            :key="tab">{{ tab }}</button>
  </div>
  <div class="tab-content">
    <div v-show="currentTab === 0">
      <table class="table">
        <thead>
          <tr>
            <th>id</th>
            <th>Title</th>
            <th>Course</th>
            <th>Instructor</th>
            <th>Человек</th>
            <th>Начало</th>
            <th>Конец</th>
            <th>Действия</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="groups.length && courses[group.course_id].visible && new Date(group.start) < new Date() &&
            new Date(group.end) > new Date()" v-for="group in filteredGroups" :key="group.id" :group="group" @dblclick="editGroup(group)">
            <td>
              {{ group.id }}
            </td>
            <td>
              <div v-show="group != editedGroup">
                <router-link :to="`/manager/groups/${group.slug}`">
                  {{ group.title }}
                </router-link>
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <input v-model.lazy="group.title" @keyup.enter="updateGroup(group)" class="form-control">
              </div>
            </td>
            <td>
              <div v-show="group != editedGroup">
                {{ courses[group.course_id]['title'] }}
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <select v-model="group.course_id" @keyup.enter="updateGroup(group)" class="form-control">
                  <option v-if="course.visible" v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">{{
                    course.title }}
                  </option>
                </select>
              </div>
            </td>
            <td>
              <div v-show="group != editedGroup">
                {{ users[group.instructor_id].name }}
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <select v-model="group.instructor_id" @keyup.enter="updateGroup(group)" class="form-control">
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
              <div v-show="group != editedGroup">
                {{ group.start | formatDate }}
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <datepicker @keyup.enter="updateGroup(group)" v-model.lazy="group.start">
                </datepicker>
              </div>
            </td>
            <td>
              <div v-show="group != editedGroup">
                {{ group.end | formatDate }}
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <datepicker @keyup.enter="updateGroup(group)" v-model.lazy="group.end">
                </datepicker>
              </div>
            </td>
            <td v-if="showGroupLink()">
              <div v-show="group === editedGroup" @click="updateGroup(group)">
                <i class="far fa-edit"></i>
              </div>
            </td>
            <td>
              <i class="fa fa-trash-alt float-right btn btn-sm btn-danger" @click="alertDisplay(group)"></i>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div v-show="currentTab === 1">
      <table class="table">
        <thead>
          <tr>
            <th>id</th>
            <th>Title</th>
            <th>Course</th>
            <th>Instructor</th>
            <th>Человек</th>
            <th>Начало</th>
            <th>Конец</th>
            <th>Действия</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="groups.length && courses[group.course_id].visible && new Date(group.start) < new Date() && new Date(group.end) < new Date()" v-for="group in filteredGroups" :key="group.id" :group="group" @dblclick="editGroup(group)">
            <td>
              {{ group.id }}
            </td>
            <td>
              <div v-show="group != editedGroup">
                <router-link :to="`/manager/groups/${group.slug}`">
                  {{ group.title }}
                </router-link>
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <input v-model.lazy="group.title" @keyup.enter="updateGroup(group)" class="form-control">
              </div>
            </td>
            <td>
              <div v-show="group != editedGroup">
                {{ courses[group.course_id]['title'] }}
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <select v-model="group.course_id" @keyup.enter="updateGroup(group)" class="form-control">
                  <option v-if="course.visible" v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">{{
                    course.title }}
                  </option>
                </select>
              </div>
            </td>
            <td>
              <div v-show="group != editedGroup">
                {{ users[group.instructor_id].name }}
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <select v-model="group.instructor_id" @keyup.enter="updateGroup(group)" class="form-control">
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
              <div v-show="group != editedGroup">
                {{ group.start | formatDate }}
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <datepicker @keyup.enter="updateGroup(group)" v-model.lazy="group.start">
                </datepicker>
              </div>
            </td>
            <td>
              <div v-show="group != editedGroup">
                {{ group.end | formatDate }}
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <datepicker @keyup.enter="updateGroup(group)" v-model.lazy="group.end">
                </datepicker>
              </div>
            </td>
            <td v-if="showGroupLink()">
              <div v-show="group === editedGroup" @click="updateGroup(group)">
                <i class="far fa-edit"></i>
              </div>
            </td>
            <td>
              <i class="fa fa-trash-alt float-right btn btn-sm btn-danger" @click="alertDisplay(group)"></i>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div v-show="currentTab === 2">
      <table class="table">
        <thead>
          <tr>
            <th>id</th>
            <th>Title</th>
            <th>Course</th>
            <th>Instructor</th>
            <th>Человек</th>
            <th>Начало</th>
            <th>Конец</th>
            <th>Действия</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="groups.length && courses[group.course_id].visible && new Date(group.start) > new Date()" v-for="group in filteredGroups" :key="group.id" :group="group" @dblclick="editGroup(group)">
            <td>
              {{ group.id }}
            </td>
            <td>
              <div v-show="group != editedGroup">
                <router-link :to="`/manager/groups/${group.slug}`">
                  {{ group.title }}
                </router-link>
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <input v-model.lazy="group.title" @keyup.enter="updateGroup(group)" class="form-control">
              </div>
            </td>
            <td>
              <div v-show="group != editedGroup">
                {{ courses[group.course_id]['title'] }}
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <select v-model="group.course_id" @keyup.enter="updateGroup(group)" class="form-control">
                  <option v-if="course.visible" v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">{{
                    course.title }}
                  </option>
                </select>
              </div>
            </td>
            <td>
              <div v-show="group != editedGroup">
                {{ users[group.instructor_id].name }}
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <select v-model="group.instructor_id" @keyup.enter="updateGroup(group)" class="form-control">
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
              <div v-show="group != editedGroup">
                {{ group.start | formatDate }}
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <datepicker @keyup.enter="updateGroup(group)" v-model.lazy="group.start">
                </datepicker>
              </div>
            </td>
            <td>
              <div v-show="group != editedGroup">
                {{ group.end | formatDate }}
              </div>
              <div class="form-group" v-show="group == editedGroup" v-on:blur="group.editedGroup=false; $emit('update')">
                <datepicker @keyup.enter="updateGroup(group)" v-model.lazy="group.end">
                </datepicker>
              </div>
            </td>
            <td v-if="showGroupLink()">
              <div v-show="group === editedGroup" @click="updateGroup(group)">
                <i class="far fa-edit"></i>
              </div>
            </td>
            <td>
              <i class="fa fa-trash-alt float-right btn btn-sm btn-danger" @click="alertDisplay(group)"></i>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
  <div class="clearfix btn-group col-md-2 offset-md-5">
    <button type="button" class="btn btn-sm btn-outline-secondary" v-if="page != 1" @click="page--"></button>
    <button type="button" class="btn btn-sm btn-outline-secondary" v-for="pageNumber in pages.slice(page-1, page+5)" @click="page = pageNumber" :key="pageNumber"> {{pageNumber}}
    </button>
    <button type="button" @click="page++" v-if="page < pages.length" class="btn btn-sm btn-outline-secondary"> >
    </button>
  </div>
</div>
</template>
<script>
import Manager from '@/components/layouts/manager/Manager'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'GroupList',
  data() {
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
      title: '',
      instructor: {
        name: ''
      },
      course: {
        title: ''
      },
      names: [],
      group: {
        title: '',
        course: '',
        instructor: '',
        start: '',
        end: ''
      },
      groups: [],
      courses: [],
      enrollments: {},
      editedGroup: '',
      resource_url: '/manager/groups/'
    }
  },
  computed: {
    filteredGroups() {
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
  created() {
    this.$emit('update:layout', Manager)
    if (this.$store.state.signedIn && this.$store.getters.isManager) {
      this.$http.secured.get(`/manager/groups`)
        .then(response => {
          this.groups = response.data.groups
          this.enrollments = response.data.enrollments
        })
        .catch(error => {
          this.setError(error, 'Something went wrong')
        })
      this.$http.secured.get('/manager/users')
        .then(response => {
          this.users = response.data.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
      this.$http.secured.get('/manager/users/instructors')
        .then(response => {
          this.instructors = response.data
        })
        .catch(error => {
          this.setError(error, 'Something went wrong')
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
  watch: {
    groups() {
      this.setPages()
    }
  },
  methods: {
    updateResource(data) {
      this.groups = data
    },
    reset() {
      this.search = ''
      this.courseList = ''
      this.startDate = ''
      this.endDate = ''
    },
    setError(error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    showGroupLink() {
      return this.$store.getters.isAdmin || this.$store.getters.isManager
    },
    editGroup(group) {
      this.editedGroup = group
    },
    updateGroup(group) {
      this.editedGroup = ''
      if (this.editedGroup) {
        this.$http.secured.patch(`/manager/groups/${group.id}`, this.group)
          .then(response => this.updateSuccessful(response))
          .catch(error => this.updateFailed(error))
      } else {
        this.notice = ''
        this.error = ''
      }
    },
    updateSuccessful(response) {
      this.notice = 'Group details have updated'
      this.error = ''
    },
    updateFailed(error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    setPages() {
      let numberOfPages = Math.ceil(this.groups.length / this.perPage)
      for (let index = 1; index <= numberOfPages; index++) {
        this.pages.push(index)
      }
    },
    paginate(groups) {
      let page = this.page
      let perPage = this.perPage
      let from = (page * perPage) - perPage
      let to = (page * perPage)
      return groups.slice(from, to)
    },
    alertDisplay(group) {
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
          this.removeGroup(group)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  components: {
    Manager,
    Datepicker
  }
}
</script>
