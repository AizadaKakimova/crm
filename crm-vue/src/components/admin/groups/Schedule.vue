<template>
    <div>
        <b-card header="Расписание">
            <div class="tabs">
                <div class="d-flex justify-content-end">
                    <button class="btn btn-outline-primary mb-3" v-for="(branch, index) in branches" :class="{active : currentTab === index}" @click="currentTab = index">{{ branch.name }}</button>
                </div>
            </div>
            <div class="tab-content">
                <div v-show="currentTab === 0">
                    <table class="table table-responsive table-bordered">
                        <tr>
                            <td></td>
                            <td v-for="item in days">{{item.day}}</td>
                        </tr>
                        <tr v-for="time in times">
                            <td>{{time.item}}</td>
                            <td v-for="item in days" width="13%" height="100">
                                    <tr>
                                    <td v-for="group in groups" v-if="time.item===group.time[0] && item.day===group.day[0] && groups.length && group.branch_id===branches[0].id && courses[group.course_id].visible && new Date(group.start) < new Date() &&
                            new Date(group.end) > new Date()">
                                        <strong><router-link :to="`/admin/groups/${group.slug}`">{{group.title}}</router-link></strong>
                                        <br><font-awesome-icon icon="book" class="fa-xs iconsGroup"/>{{ courses[group.course_id].title }}
                                        <br><font-awesome-icon icon="chalkboard-teacher"  class="fa-xs iconsGroup"/>{{ instructors[group.instructor_id].name }}
                                        </td>
                                        <td v-for="group in groups" v-if="time.item===group.time[1] && item.day===group.day[1] && groups.length && group.branch_id===branches[0].id && courses[group.course_id].visible && new Date(group.start) < new Date() &&
                            new Date(group.end) > new Date()">
                                        <strong><router-link :to="`/admin/groups/${group.slug}`">{{group.title}}</router-link></strong>
                                        <br><font-awesome-icon icon="book" class="fa-xs iconsGroup"/>{{ courses[group.course_id].title }}
                                        <br><font-awesome-icon icon="chalkboard-teacher"  class="fa-xs iconsGroup"/>{{ instructors[group.instructor_id].name }}
                                        </td>
                                    </tr>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="tab-content">
                <div v-show="currentTab === 1">
                    <table class="table table-responsive table-bordered">
                        <tr>
                            <td></td>
                            <td v-for="item in days">{{item.day}}</td>
                        </tr>
                        <tr v-for="time in times">
                            <td>{{time.item}}</td>
                            <td v-for="item in days" width="13%" height="100">
                                    <tr>
                                    <td v-for="group in groups" v-if="time.item===group.time[0] && item.day===group.day[0] && groups.length && group.branch_id===branches[1].id && courses[group.course_id].visible && new Date(group.start) < new Date() &&
                            new Date(group.end) > new Date()">
                                        <strong><router-link :to="`/admin/groups/${group.slug}`">{{group.title}}</router-link></strong>
                                        <br><font-awesome-icon icon="book" class="fa-xs iconsGroup"/>{{ courses[group.course_id].title }}
                                        <br><font-awesome-icon icon="chalkboard-teacher"  class="fa-xs iconsGroup"/>{{ instructors[group.instructor_id].name }}
                                        </td>
                                        <td v-for="group in groups" v-if="time.item===group.time[1] && item.day===group.day[1] && groups.length && group.branch_id===branches[1].id && courses[group.course_id].visible && new Date(group.start) < new Date() &&
                            new Date(group.end) > new Date()">
                                        <strong><router-link :to="`/admin/groups/${group.slug}`">{{group.title}}</router-link></strong>
                                        <br><font-awesome-icon icon="book" class="fa-xs iconsGroup"/>{{ courses[group.course_id].title }}
                                        <br><font-awesome-icon icon="chalkboard-teacher"  class="fa-xs iconsGroup"/>{{ instructors[group.instructor_id].name }}
                                        </td>
                                    </tr>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </b-card>
    </div>
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'


export default {
    name: 'GroupSchedule',
    data() {
        return{
            courses: {},
            loading: true,
            branches: [],
            group: {
                title: '',
                start: '',
                end: '',
                branch_id: ''
            },
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
            groups: [],
            currentTab: 0
        }
    },
    created () {
        this.$emit('update:layout', Admin)
        if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
            this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/groups`)
                .then(response => {
                    this.groups = response.data.groups
                    this.loading  = false
                    this.courses = response.data.courses.reduce((acc, value) => {
                        acc[value.id] = value
                        return acc
                    }, {})
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
            this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/branches`)
                .then(response => {
                this.branches = response.data.branches
            })        
        }
    },
    methods: {
        setError (error, text) {
            this.error = (error.response && error.response.data && error.response.data.error) || text
            this.notice = ''
        }
    },
    components: {Admin}

}
</script>
