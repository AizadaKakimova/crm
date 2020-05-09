<template>
    <div class="col-md-10">
        <b-alert class="col-4 alert-danger" v-if="error" show dismissible ariant="alert">
            {{ error }}
        </b-alert>
        <b-alert  v-if="notice" show dismissible ariant="success">
            {{ notice }}
        </b-alert>
        <b-card header="Курсы">
            <div class = "table-responsive table-hover table-striped">
                <table class="table first-td-padding table-striped">
                    <tr>
                        <th>Группа</th>
                        <th>Курс</th>
                        <th>Преподаватель</th>
                        <th>Старт</th>
                        <th>Конец</th>
                        <th>Цена</th>
                        <th>Действия</th>
                    </tr>
                    <tr v-for="group in groups">
                        <td>{{group.title}}</td>
                        <td>{{course[group.course_id].title}}</td>
                        <td>{{instructors[group.instructor_id].name}}</td>
                        <td>{{group.start | formatDate}}</td>
                        <td>{{group.end | formatDate}}</td>
                        <td>{{course[group.course_id].price}}</td>
                        <td><button type="button" class="btn btn-sm btn-primary" data-toggle="modal" data-target="#exampleModal">Записаться</button></td>
                    </tr>
                </table>
            </div>
            <div class="modal fade mt-5" id="exampleModal" tabIndex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-md" role="document">
                    <div class="modal-content">
                        <h1 class="my-4 ml-5 text-blue3" id="exampleModalLabel"><span>оставить заявку</span></h1>
                        <button type="button" class="close btn btn-link offset-10 mt-3" data-dismiss="modal" aria-label="Close" id = "close">
                            <font-awesome-icon icon='times' class='icon' style="color:#000"/>
                        </button>
                        <div class="modal-body text-left align-items-center">
                            <form class="mt-3" @submit.prevent="addRequest()">
                                <div class="alert alert-danger" v-if="error">{{ error }}</div>
                                <!-- <div class="form-group mt-3 col-10 ml-auto mr-auto">
                                    <label htmlFor="inputAddress" class="mt-3 modalLabel">Телефон<span class="colortext">*</span></label>
                                    <input v-model.trim="request.phone" v-mask="'+# (###) ### ## ##'" type="text" class="form-control inputs w-100" id="inputAddress" required>
                                </div> -->
                                <div class="orm-group mt-3 col-10 ml-auto mr-auto">
                                    <label htmlFor="exampleFormControlSelect1" class="mt-3 modalLabel">Выберите курс<span class="colortext">*</span></label>
                                    <select class="form-control inputs w-100" v-model="request.course_id">
                                        <option v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">{{course.title}}</option>
                                    </select>
                                </div>
                                <div class="form-group mt-3 col-10 ml-auto mr-auto" v-if="branches.length>1">
                                    <label htmlFor="exampleFormControlSelect1" class="mt-3 modalLabel">Какая точка для Вас ближе?</label>
                                    <select class="form-control inputs w-100" v-model="request.branch_id">
                                        <option v-for="branch in branches" v-bind:value="branch.id" v-bind:key="branch.id">{{ branch.address }}</option>
                                    </select>
                                </div>
                                <div class="form-group col-5 ml-auto mr-auto w-100">
                                    <button type="submit" class="btn mt-4 btnMsg">Оставить заявку</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>   
            </div>
        </b-card>
    </div>
</template>
<script>
import Student from '@/components/layouts/student/Student.vue'

export default {
    name: 'CoursesStudent',
    data () {
        return {
            request: {
                name: '',
                phone: '',
                branch_id: '',
                course_id: ''
            },
            groups: {
                title: '',
                start: '',
                end: ''
            },
            notice: '',
            error: ''
        }
    },
    created () {
        this.$emit('update:layout', Student)
        this.checkSignedIn()
        this.getCourses()
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/branches`)
        .then(response => 
          this.branches = response.data.branches
          )
        .catch(error => {this.setError(error, 'Что-то пошло не так')})
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/courses`)
        .then(response => 
          this.courses = response.data.courses
          )
        .catch(error => {this.setError(error, 'Что-то пошло не так')})
    },
    methods: {
        getCourses() {
            this.currentCity = this.$store.state.currentCity
            this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}`)
            .then(response => {
                this.groups = response.data.groups
                this.instructors = response.data.instructors.reduce((acc, value) => {
                    acc[value.id] = value
                    return acc
                }, {})
                this.course = response.data.courses.reduce((acc, value) => {
                    acc[value.id] = value
                    return acc
                }, {})
            })
        },
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
      },
      addRequest () {
        this.request.name = this.$store.state.currentUser.name
        this.request.phone = this.$store.state.currentUser.phone
        const value = this.request
        if (!value) {
            return
        }
        if(this.$store.getters.getCurrentCity.id===1){
            
            // this.types.push()
        } else {
            this.shown=false
        }
        this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/send_request`, this.request)
            .then(response => this.createSuccessful(response))
            .catch(error => this.createFailed(error))
        },
        createSuccessful (response) {
            this.notice = 'Заявка отправлена'
            this.error = ''
            $('#exampleModal').modal('hide')
            $('#modalSuccess').modal('show')
        },
        createFailed (error) {
            this.error = (error.response && error.response.data && error.response.data.error) || ''
        },
        closeModal () {
            $('#menuModal').modal('hide')
        }
    }
}
</script>