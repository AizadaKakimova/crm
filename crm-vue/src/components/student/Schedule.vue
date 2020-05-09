<template>
    <div class="col-10">
        <b-card header="Расписание">
            <table class="table table-responsive table-bordered">
                <tr>
                    <td></td>
                    <td v-for="item in days">{{item.day}}</td>
                </tr>
                <tr v-for="time in times">
                    <td>{{time.item}}</td>
                    <td v-for="item in days" width="13%" height="100">
                            <tr>
                            <td v-for="group in groups" v-if="time.item===group.time[0] && item.day===group.day[0] && groups.length &&
                    new Date(group.end) > new Date()">
                    
                                <strong><router-link :to="`/student/groups/${group.id}`">{{group.title}}</router-link></strong>
                                <br><font-awesome-icon icon="book" class="fa-xs iconsGroup"/>{{ group.course_id}}
                                <br><font-awesome-icon icon="chalkboard-teacher"  class="fa-xs iconsGroup"/>{{ group.instructor_id }}
                            </td>
                            <td v-for="group in groups" v-if="time.item===group.time[1] && item.day===group.day[1] && groups.length &&
                    new Date(group.end) > new Date()">
                    
                                <strong><router-link :to="`/student/groups/${group.id}`">{{group.title}}</router-link></strong>
                                <br><font-awesome-icon icon="book" class="fa-xs iconsGroup"/>{{ group.course_id}}
                                <br><font-awesome-icon icon="chalkboard-teacher"  class="fa-xs iconsGroup"/>{{ group.instructor_id }}
                            </td>
                        </tr>
                    </td>
                </tr>
      </table>
        </b-card>
    </div>
</template>

<script>
import Student from '@/components/layouts/student/Student.vue'
import Breadcrumbs from '@/components/Breadcrumbs'

export default {
    name: 'StudentSchedule',
    data () {
        return {
            days: [
                {day: 'Mon'},
                {day: 'Tue'},
                {day: 'Wed'},
                {day: 'Thu'},
                {day: 'Fri'},
                {day: 'Sat'},
                {day: 'Sun'},
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
                branch_id: ''
            },
            groups: []
        }
    },
    created () {
        this.$emit('update:layout', Student)
        this.checkSignedIn()
        this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/student/dashboard`)
                .then(response => {
                  this.students = response.data.students
                }) 
        this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/student/groups`)
                .then(response => {
                  this.groups = response.data.groups
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
        }
    }
}
</script>