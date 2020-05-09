<template>
    <div class="row">
        <div class="groups col-md-5">
            <b-card header = "Домашнее задание">
                <input type="file" ref="inputFile" @change=uploadFile() >
                  <!-- <file-upload :url='url' :thumb-url='thumbUrl' :headers="headers" @change="onFileChange"></file-upload> -->
                    <button @click=createItem>Create this Item !</button>
            </b-card>
        </div>
        <div class="groups col-md-5">
            <b-card header = "Дополнительные материалы">
            </b-card>
        </div>
    </div>
</template>
<script>
import Instructor from '@/components/layouts/instructor/Instructor.vue'
import { FileUploadService } from 'v-file-upload'

export default {
    name: 'InstructorLectures',
    data () {
        return {
            inputPicture: null,
            group: {
                hw: ''
            }
        }
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
        uploadFile: function() {
            this.inputPicture = this.$refs.inputFile.files[0]
        },
        // Collecting everything inside our FormData object
        createItem: function() {
            const params = {
                'picture': this.inputPicture
            }
            let formData = new FormData()
            Object.entries(params).forEach(
                ([key, value]) => formData.append(key, value)
            )
            this.group.hw = this.$refs.inputFile.files[0]
            alert(this.group.hw)
        // Finally, sending the POST request with our beloved Axios
            // axios.post('/item', formData)
            // alert(formData)
            this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/instructor/groups/${this.$route.params.id}`, {
                // alert(formData)
                group: {
                    hw: this.group.hw
                }
            })
                .then(response => { this.createSuccessful(response) })
                .catch(error => { this.setError(error, 'Пожалуйста, проверьте поля!') })
        }
    }
}
</script>