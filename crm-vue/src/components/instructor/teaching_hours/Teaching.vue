<template>
    <div class="groups col-md-6 mx-auto">
      <b-card header="Часы">
        <div class="col-8 mx-auto">
      <b-alert  v-if="error" show dismissible variant="danger">
        {{ error }}
      </b-alert>
      <b-alert  v-if="notice" show dismissible variant="success">
        {{ notice }}
      </b-alert>
          <p>Часы работы в этом месяце(Группа): {{teaching_hours}}</p>
          <p>Часы работы в этом месяце(Индивид): {{teaching_hours_individs}}</p>
          <input type="checkbox" v-model="checkBox" v-bind:true-value="on" v-bind:false-value="off"> Индивид
           <table>
          <tr>
                    <input type="hidden" :model="teaching.instructor_id = this.$store.getters.currentUserId" >
                    <input type="hidden" :model="teaching_individ.instructor_id = this.$store.getters.currentUserId" >
            <td>Часы:</td>
            <td><input class="form-control" v-if="checkBox===false" v-model.number="teaching.hours" type="number">
            <input class="form-control" v-else v-model.number="teaching_individ.hours" type="number"></td>
          </tr>
          <tr>
            <td height="50">Группа:</td>
            <td><select class="form-control" v-model="teaching.group_id">
            <option v-if="groups.length" v-for="group in groups"  v-bind:value="group.id" v-bind:key="group.id">
               {{ group.title }}
            </option>
          </select></td>
          </tr>
        </table>
        <button type="submit" class="btn btn-primary mb-3" @click="addHours()">Добавить</button>
                    </div>
        </b-card>
    </div>
</template>
<script>
import Instructor from '@/components/layouts/instructor/Instructor.vue'

export default {
  name: 'TeachingHours',
  data () {
    return {
      error: '',
      notice: '',
      groups: '',
      teaching_hours: '',
      success: false,
      teaching_hours_individs: '',
      checkBox: false,
      on: true,
      off: false,
      teaching_individ: {
        instructor_id: '',
        hours: ''
      },
      teaching: {
        group_id: '',
        hours: '',
        instructor_id: ''
      },
      selected: false
    }
  },
  created () {
    this.success = false
    this.$emit('update:layout', Instructor)
    this.getGroup()
    if (this.$store.state.signedIn && this.$store.getters.isInstructor) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/instructors/${this.$store.getters.currentUserId}`)
        .then(response => {
          this.teaching_hours = response.data.teaching_hours
          this.teaching_hours_individs = response.data.invdividual_hours_this_month
        })
        .catch(error => { this.setError(error, 'Что-то пошло не так') })
    }
  },
  methods: {
    getGroup () {
      if (this.$store.state.signedIn && this.$store.getters.isInstructor) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/instructor/groups`)
          .then(response => {
            this.groups = response.data.groups
          })
          .catch(error => { this.setError(error, 'Что-то пошло не так') })
      }
    },
    addHours () {
      if (this.checkBox === false) {
        this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/instructor/teaching_hours/new`, this.teaching)
          .then(response => {
            this.createSuccessful(response)
            this.teaching_hours = this.teaching_hours + this.teaching.hours
            this.success = true
          })
          .catch(error => { this.setError(error, 'Вы не выбрали группу!') })
      } else {
          this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/instructor/teaching_hours_individs/new`, this.teaching_individ)
          .then(response => {
            this.createSuccessful(response)
            this.teaching_hours_individs = Number(this.teaching_hours_individs) + Number(this.teaching_individ.hours)
            this.success = true
          })
          .catch(error => { this.setError(error, 'Вы не выбрали группу!') })
      }
    },
    createSuccessful (response) {
      this.notice = 'Часы добавлены'
      this.error = ''
    },
    updateResource (data) {
      this.groups = data
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    }
  },
  directives: {
    'enrollment-focus': function (el) {
      el.focus()
    }
  },
  components: { Instructor }
}
</script>
<style lang="css" scoped>
  .danger  {
    background: orange;
  }
  .success  {
    background: green;
  }
  .warning  {
    background: grey;
  }
   tr:first-child td{
   width: 200px;
  }
</style>
