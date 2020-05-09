<template>
    <div class="row">
      <div class="col-10">
        <b-card header="Преподаватель">
            <h5>Преподаватель <strong>{{ instructor.name }}</strong></h5>
            <p>Группа <strong>{{instructor.course_id}}</strong></p>
        </b-card>
      </div>
    </div>
</template>
<script>
import Student from '@/components/layouts/student/Student.vue'
import Breadcrumbs from '@/components/Breadcrumbs'

export default {
    name: 'StudentInstructor',
    data () {
        return {
            instructor: {
                id: '',
                name: ''
            }
        }
    },
    created () {
        this.$emit('update:layout', Student)
        this.checkSignedIn()
        this.getInstructor()
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
        getInstructor () {
            this.$http.secured.get(`${this.$store.getters.getCurrentCity.slug}/student/groups`)
            .then(response => {
                this.groups = response.data.groups
                this.courses = response.data.courses.reduce((acc, value) => {
                    acc[value.id] = value
                    return acc
                }, {})   
                this.instructor = response.data.instructors
                for(let i=0; i<this.instructor.length; i++) {
                    if(this.$route.params.id == this.instructor[i].id) {
                        this.instructor = this.instructor[i]

                    }
                }
            })     
            .catch(error => {
                this.setError(error, 'Что-то пошло не так')
            })
        }
    }
}
</script>