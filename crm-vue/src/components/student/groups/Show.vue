<template>
    <div>
        <div class="col-10">
            <b-alert  v-if="error" show dismissible variant="danger">
                {{ error }}
            </b-alert>
            <b-alert  v-if="notice" show dismissible variant="success">
                {{ notice }}
            </b-alert>
            <b-card header="Группа">
                    <h4>Группа {{ group.title }}</h4>
            <p><font-awesome-icon icon="book" style="width: 2rem" class="iconsGroup"/> {{ course.title }}</p>
            <p><font-awesome-icon icon="chalkboard-teacher" style="width: 2rem" class="iconsGroup"/>{{ instructor.name }}</p>
            <p><font-awesome-icon :icon="['fas', 'calendar-alt']" style="width: 2rem" class="iconsGroup"/>{{ group.start | formatDate }} до {{ group.end | formatDate }}</p>
            <p v-for="enrollment in enrollments" v-if="enrollment.user_id===$store.getters.currentUserId">Мои коины <strong>{{enrollment.coins}}</strong></p>
                <div class = "table-responsive table-hover table-striped">
                <table class="table first-td-padding table-striped">
                <thead>
                <tr>
                    <th>Имя</th>
                    <th>Почта</th>
                    <th>Коины</th>
                    <th>Раздать коины</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="(enrollment, index) in enrollments" v-if="$store.state.currentUser.id !== enrollment.user_id">
                    <td>{{students[enrollment.user_id].name}}</td>
                    <td>{{students[enrollment.user_id].email}}</td>
                    <td>{{enrollment.coins}}</td>
                    <td>
                        <input width="10" type="number" v-model="coins[index]">
                        <button type="button" name="button" class="btn btn-sm btn-success" @click="addCoins(enrollment.id,index, students[enrollment.user_id].name)">+</button>
                    </td>
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
    name: 'StudentGroupShow',
    data () {
        return {
            error: '',
            notice: '',
            enrollments: {
                user_id: '',
                id: ''
            },
            students: {
                id: '',
                name: '',
                email: ''
            },
            group: {
                title:''
            },
            course: {
                title: ''
            },
            instructor: {
                name: ''
            },
            coins: [],
            enrollment: {
                coins: ''
            }
        }
    },
    created () {
        this.$emit('update:layout', Student)
        this.checkSignedIn()
        this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/student/dashboard`)
                .then(response => {
                  this.groups = response.data.groups
                })
        this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/student/groups/${this.$route.params.slug}`) 
            .then(response => {
                this.group = response.data.group
                this.students = response.data.students.reduce((acc, value) => {
                    acc[value.id] = value
                    return acc
                }, {}) 
                this.instructor = response.data.instructor
                this.enrollments = response.data.enrollments
                this.course = response.data.course
            })
        this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/student/groups`) 
            .then(response => {
                this.enrollment = response.data.enrollments
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
        },
        addCoins (enrollmentId, index, name) {
            this.$http.secured.put(`/${this.$store.getters.getCurrentCity.slug}/student/groups/coins/add?enrollment_id=${enrollmentId}&coins=${this.coins[index]}`)
                .then(response => {
                // this.createSuccessful(response, name, this.coins[index])
                this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/student/groups/${this.$route.params.slug}`)
                    .then(response => {
                    this.group = response.data.group
                    this.enrollments = response.data.enrollments
                    this.coins = []
                    })
                })
                // .catch(error => { this.setError(error, 'Коины не добавились!') })
            this.correctCoins(index, name)
        },
        correctCoins (index, name) {
            for(let i=0;i<this.enrollments.length;i++){
                if(this.$store.state.currentUser.id===this.enrollments[i].user_id) {
                    this.enrollmentId = this.enrollments[i].id
                    this.$http.secured.put(`/${this.$store.getters.getCurrentCity.slug}/student/groups/coins/minus?enrollment_id=${this.enrollmentId}&coins=${this.coins[index]}`)
                        .then(response => {
                        this.createSuccessful(response, name, this.coins[index])
                        this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/student/groups/${this.$route.params.slug}`)
                            .then(response => {
                            this.group = response.data.group
                            this.enrollments = response.data.enrollments
                            this.coins = []
                            })
                        })
                }
            }            
        },
        createSuccessful (response, name, coins) {
            this.notice = name + ' ты получил ' + coins + ' коинов!'
            this.error = ''
        },
        setError (error, text, index) {
            this.error = (error.response && error.response.data && error.response.data.error) || text
        },
    }
}
</script>