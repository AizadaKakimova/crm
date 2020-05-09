<template>
  <div class="groups col-md-10">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <div class="row">
      <div class="groups col-md-4">
    <h3>Группа {{ group.title }}</h3>
    <ul>
      <li>{{ course_title }}</li>
      <li>{{ instructor.name }}</li>
      <li>{{ group.start | formatDate }}</li>
      <li>{{ group.end | formatDate }}</li>
    </ul>

    <div class="">
      <h5>Общая ожидаема сумма: {{overall_amount}}</h5>
      <h5>Общая полученнная сумма: {{overall_paid}}</h5>
    </div>
      <router-link :to="`/manager/groups/${this.$route.params.slug}/edit`" class="btn btn-success">
        Edit
      </router-link>
      <router-link :to="`/manager/groups/${this.$route.params.slug}/enrollments/new`" class="btn btn-primary">
        Add student
      </router-link>
    </div>
    <div class="groups col-md-8" @click="updateEnrollment(editedEnrollment)">
    </div>
  </div>
  <h4>Enrolled:</h4>
    <table class="table">
      <thead>
      <tr>
        <th>id</th>
        <th>Name</th>
        <th>phone</th>
        <th>Email</th>
        <th>Статус</th>
        <th>Оплаты</th>
        <th>Действия</th>
      </tr>
      </thead>
      <tbody>
      <tr v-if="enrollments_enrolled.length" v-for="enrollment in enrollments_enrolled" :key='enrollment.id'
          :request="enrollment"
          v-bind:class="{enrolled:enrollment.status == 'enrolled'}">
        <td>
          {{ enrollment.id }}
        </td>
        <td>
          <router-link :to="`/manager/groups/${group.slug}/enrollments/${enrollment.id}`">
            {{ users[enrollment.user_id].name }}
          </router-link>
        </td>
        <td>
          {{ users[enrollment.user_id].phone }}
        </td>
        <td>
          {{ users[enrollment.user_id].email }}
        </td>
        <td>
          <div v-show="enrollment != editedEnrollment" @dblclick="editEnrollment(enrollment)" :key="enrollment.status">
            {{ enrollment.status }}
          </div>
          <div class="form-group" v-show="enrollment == editedEnrollment">
            <select v-model="enrollment.status" v-enrollment-focus
                    @keyup.enter="updateEnrollment(enrollment); $emit('update')" class="form-control" id="status"
                    v-on:blur="enrollment.editedEnrollment=false; $emit('update')">
              <option value='skipped'>skipped</option>
              <option value='dropped'>dropped</option>
              <option value='attending'>attending</option>
              <option value='enrolled'>enrolled</option>
              <option value='completed'>completed</option>
            </select>
          </div>
        </td>
        <td>
          <div v-if="paid_days[enrollment.id] > 0" class="btn btn btn-sm btn-success btn-secondary">
            {{ paid_days[enrollment.id] }}
          </div>
          <div v-if="paid_days[enrollment.id] === 0" class="btn btn-sm btn-warning">
            {{ paid_days[enrollment.id] }}
          </div>
          <div v-if="paid_days[enrollment.id] < 0" class="btn btn btn-sm btn-danger">
            {{ paid_days[enrollment.id] }}
          </div>
          | {{paid_sum[enrollment.id]}} | {{paid_amount[enrollment.id]}}
        </td>
        <td v-if="showEnrollmentLink()">
          <div v-show="enrollment === editedEnrollment" @click="updateEnrollment(enrollment)">
            <i class="btn btn-primary mb-3">Edit</i>
          </div>
        </td>
      </tr>
      </tbody>
    </table>
    <h4>Dropped:</h4>
    <table class="table">
      <thead>
      <tr>
        <th>id</th>
        <th>Name</th>
        <th>phone</th>
        <th>Email</th>
        <th>Статус</th>
        <th>Оплаты</th>
        <th>Действия</th>
      </tr>
      </thead>
      <tbody>
      <tr v-if="enrollments_dropped.length" v-for="enrollment in enrollments_dropped" :key='enrollment.id'
          :request="enrollment"
          v-bind:class="{dropped:enrollment.status == 'dropped'}">
        <td>
          {{ enrollment.id }}
        </td>
        <td>
          {{ users[enrollment.user_id]['name'] }}
        </td>
        <td>
          {{ users[enrollment.user_id]['phone'] }}
        </td>
        <td>
          {{ users[enrollment.user_id]['email'] }}
        </td>
        <td>
          <div v-show="enrollment != editedEnrollment" @dblclick="editEnrollment(enrollment)" :key="enrollment.status">
            {{ enrollment.status }}
          </div>
          <div class="form-group" v-show="enrollment == editedEnrollment">
            <select v-model="enrollment.status" v-enrollment-focus
                    @keyup.enter="updateEnrollment(enrollment); $emit('update')" class="form-control" id="status"
                    v-on:blur="enrollment.editedEnrollment=false; $emit('update')">
              <option value='skipped'>skipped</option>
              <option value='dropped'>dropped</option>
              <option value='attending'>attending</option>
              <option value='enrolled'>enrolled</option>
              <option value='completed'>completed</option>
            </select>
          </div>
        </td>
        <td>0</td>
        <td v-if="showEnrollmentLink()">
          <div v-show="enrollment === editedEnrollment" @click="updateEnrollment(enrollment)">
            <i class="btn btn-primary mb-3">Edit</i>
          </div>
        </td>
      </tr>
      </tbody>
    </table>
    <h4>Skipped:</h4>
    <table class="table">
      <thead>
        <tr>
          <th>id</th>
          <th>Name</th>
          <th>phone</th>
          <th>Email</th>
          <th>Статус</th>
          <th>Оплаты</th>
          <th>Действия</th>
        </tr>
      </thead>
      <tbody>
          <tr v-if="enrollments_skipped.length" v-for="enrollment in enrollments_skipped" :key='enrollment.id' :request="enrollment" v-bind:class="{skipped:enrollment.status == 'skipped'}">
            <td>
              {{ enrollment.id }}
            </td>
            <td >
              <router-link :to="`/admin/groups/${group.id}/enrollments/${enrollment.id}`">
                {{ users[enrollment.user_id].name }}
              </router-link>
            </td>
            <td>
              {{ users[enrollment.user_id].phone }}
            </td>
            <td>
              {{ users[enrollment.user_id].email }}
            </td>
            <td>
              <div v-show="enrollment != editedEnrollment" @dblclick="editEnrollment(enrollment)" :key="enrollment.status">
                {{ enrollment.status }}
              </div>
              <div class="form-group" v-show="enrollment == editedEnrollment"
                v-on:blur= "enrollment.editedEnrollment=false; $emit('update')">
                <select v-model="enrollment.status" @keyup.enter="updateEnrollment(enrollment);
                $emit('update')" class="form-control" id="status">
                  <option value='skipped'>skipped</option>
                  <option value='dropped'>dropped</option>
                  <option value='attending'>attending</option>
                  <option value='enrolled'>enrolled</option>
                  <option value='completed'>completed</option>
                </select>
              </div>
            </td>
            <td>
              <div v-if="paid_days[enrollment.id] > 0" class="btn btn btn-sm btn-success btn-secondary">
                {{ paid_days[enrollment.id] }}
              </div>
              <div v-if="paid_days[enrollment.id] === 0" class="btn btn-sm btn-warning">
                {{ paid_days[enrollment.id] }}
              </div>
              <div v-if="paid_days[enrollment.id] < 0" class="btn btn btn-sm btn-danger">
                {{ paid_days[enrollment.id] }}
              </div>
               | {{paid_sum[enrollment.id]}} | {{paid_amount[enrollment.id]}}
            </td>
            <td v-if="showEnrollmentLink()">
              <div v-show="enrollment === editedEnrollment" @click="updateEnrollment(enrollment)">
                <i class="btn btn-primary mb-3">Edit</i>
              </div>
            </td>
            <td>
              <i class="fa fa-trash-alt float-right btn btn-sm btn-danger" @click="alertDisplay(enrollment)"></i>
             </td>
        </tr>
      </tbody>
    </table>
    <h4>Completed:</h4>
    <table class="table">
      <thead>
        <tr>
          <th>id</th>
          <th>Name</th>
          <th>phone</th>
          <th>Email</th>
          <th>Статус</th>
          <th>Оплаты</th>
          <th>Действия</th>
        </tr>
      </thead>
      <tbody>
          <tr v-if="enrollments_completed.length" v-for="enrollment in enrollments_completed" :key='enrollment.id' :request="enrollment" v-bind:class="{completed:enrollment.status == 'completed'}">
            <td>
              {{ enrollment.id }}
            </td>
            <td >
              <router-link :to="`/admin/groups/${group.id}/enrollments/${enrollment.id}`">
                {{ users[enrollment.user_id].name }}
              </router-link>
            </td>
            <td>
              {{ users[enrollment.user_id].phone }}
            </td>
            <td>
              {{ users[enrollment.user_id].email }}
            </td>
            <td>
              <div v-show="enrollment != editedEnrollment" @dblclick="editEnrollment(enrollment)" :key="enrollment.status">
                {{ enrollment.status }}
              </div>
              <div class="form-group" v-show="enrollment == editedEnrollment"
                v-on:blur= "enrollment.editedEnrollment=false; $emit('update')">
                <select v-model="enrollment.status" @keyup.enter="updateEnrollment(enrollment);
                $emit('update')" class="form-control" id="status">
                  <option value='skipped'>skipped</option>
                  <option value='dropped'>dropped</option>
                  <option value='attending'>attending</option>
                  <option value='enrolled'>enrolled</option>
                  <option value='completed'>completed</option>
                </select>
              </div>
            </td>
            <td>
              <div v-if="paid_days[enrollment.id] > 0" class="btn btn btn-sm btn-success btn-secondary">
                {{ paid_days[enrollment.id] }}
              </div>
              <div v-if="paid_days[enrollment.id] === 0" class="btn btn-sm btn-warning">
                {{ paid_days[enrollment.id] }}
              </div>
              <div v-if="paid_days[enrollment.id] < 0" class="btn btn btn-sm btn-danger">
                {{ paid_days[enrollment.id] }}
              </div>
               | {{paid_sum[enrollment.id]}} | {{paid_amount[enrollment.id]}}
            </td>
            <td v-if="showEnrollmentLink()">
              <div v-show="enrollment === editedEnrollment" @click="updateEnrollment(enrollment)">
                <i class="btn btn-primary mb-3">Edit</i>
              </div>
            </td>
            <td>
              <i class="fa fa-trash-alt float-right btn btn-sm btn-danger" @click="alertDisplay(enrollment)"></i>
             </td>
        </tr>
      </tbody>
    </table>
    <h4>Attending:</h4>
    <table class="table">
      <thead>
        <tr>
          <th>id</th>
          <th>Name</th>
          <th>phone</th>
          <th>Email</th>
          <th>Статус</th>
          <th>Оплаты</th>
          <th>Действия</th>
        </tr>
      </thead>
      <tbody>
          <tr v-if="enrollments_attending.length" v-for="enrollment in enrollments_attending" :key='enrollment.id' :request="enrollment" v-bind:class="{attending:enrollment.status == 'attending'}">
            <td>
              {{ enrollment.id }}
            </td>
            <td >
              <router-link :to="`/admin/groups/${group.id}/enrollments/${enrollment.id}`">
                {{ users[enrollment.user_id].name }}
              </router-link>
            </td>
            <td>
              {{ users[enrollment.user_id].phone }}
            </td>
            <td>
              {{ users[enrollment.user_id].email }}
            </td>
            <td>
              <div v-show="enrollment != editedEnrollment" @dblclick="editEnrollment(enrollment)" :key="enrollment.status">
                {{ enrollment.status }}
              </div>
              <div class="form-group" v-show="enrollment == editedEnrollment"
                v-on:blur= "enrollment.editedEnrollment=false; $emit('update')">
                <select v-model="enrollment.status" @keyup.enter="updateEnrollment(enrollment);
                $emit('update')" class="form-control" id="status">
                  <option value='skipped'>skipped</option>
                  <option value='dropped'>dropped</option>
                  <option value='attending'>attending</option>
                  <option value='enrolled'>enrolled</option>
                  <option value='completed'>completed</option>
                </select>
              </div>
            </td>
            <td>
              <div v-if="paid_days[enrollment.id] > 0" class="btn btn btn-sm btn-success btn-secondary">
                {{ paid_days[enrollment.id] }}
              </div>
              <div v-if="paid_days[enrollment.id] === 0" class="btn btn-sm btn-warning">
                {{ paid_days[enrollment.id] }}
              </div>
              <div v-if="paid_days[enrollment.id] < 0" class="btn btn btn-sm btn-danger">
                {{ paid_days[enrollment.id] }}
              </div>
               | {{paid_sum[enrollment.id]}} | {{paid_amount[enrollment.id]}}
            </td>
            <td v-if="showEnrollmentLink()">
              <div v-show="enrollment === editedEnrollment" @click="updateEnrollment(enrollment)">
                <i class="btn btn-primary mb-3">Edit</i>
              </div>
            </td>
            <td>
              <i class="fa fa-trash-alt float-right btn btn-sm btn-danger" @click="alertDisplay(enrollment)"></i>
             </td>
        </tr>
      </tbody>
    </table>
    <div>
      <router-link to="/manager/groups">Back To groups List</router-link>
    </div>
    <div class="col-md-12" @click="updateEnrollment(editedEnrollment)" style="height: 35%"></div>
  </div>
</template>
<script>
import Manager from '@/components/layouts/manager/Manager'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'GroupShowManager',
  data () {
    return {
      error: '',
      notice: '',
      users: {},
      title: '',
      group: {
        title: '',
        course_id: '',
        instructor_id: '',
        start: '',
        end: ''
      },
      course_title: '',
      instructor: '',
      enrollment: '',
      enrollments: '',
      enrollments_enrolled: {
        status: ''
      },
      enrollments_dropped: {
        status: ''
      },
      enrollments_skipped: {
        status: ''
      },
      enrollments_attending: {
        status: ''
      },
      enrollments_completed: {
        status: ''
      },
      editedEnrollment: '',
      resource_url: '/manager/groups/:slug',
      paid: '',
      left: '',
      paid_days: '',
      paid_amount: '',
      paid_sum: '',
      overall_paid: '',
      overall_amount: ''
    }
  },
  created () {
    this.$emit('update:layout', Manager)
    this.getGroup()
  },
  methods: {
    getGroup () {
      if (this.$store.state.signedIn && this.$store.getters.isManager) {
        this.$http.secured.get(`/admin/groups/${this.$route.params.slug}`)
          .then(response => {
            this.group = response.data.group
            this.enrollments_enrolled = response.data.enrollments_enrolled
            this.enrollments_dropped = response.data.enrollments_dropped
            this.enrollments_skipped = response.data.enrollments_skipped
            this.enrollments_completed = response.data.enrollments_completed
            this.enrollments_attending = response.data.enrollments_attending
            this.paid_days = response.data.paid_days
            this.paid_amount = response.data.paid_amount
            this.paid_sum = response.data.paid_sum
            this.overall_amount = response.data.overall_amount
            this.overall_paid = response.data.overall_paid
            this.instructor = response.data.instructor
            this.course_title = response.data.course_title
            this.users = response.data.users.reduce((acc, value) => {
              acc[value.id] = value
              return acc
            }, {})
          })
          .catch(error => { this.setError(error, 'Error') })
      } else {
        this.$router.replace('/')
      }
    },
    updateResource (data) {
      this.groups = data
    },
    showEnrollmentLink () {
      return this.$store.getters.isManager
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    editEnrollment (enrollment) {
      this.editedEnrollment = enrollment
    },
    updateEnrollment (enrollment) {
      if (this.editedEnrollment) {
        this.editedEnrollment = ''
        this.$http.secured.patch(`/manager/enrollments/${enrollment.id}`, {enrollment: {status: enrollment.status}})
          .then(response => {
            switch (enrollment.status) {
              case 'enrolled':
                this.enrollments_dropped.splice(this.enrollments_dropped.indexOf(enrollment), 1)
                this.enrollments_completed.splice(this.enrollments_completed.indexOf(enrollment), 1)
                this.enrollments_attending.splice(this.enrollments_attending.indexOf(enrollment), 1)
                this.enrollments_skipped.splice(this.enrollments_skipped.indexOf(enrollment), 1)
                this.enrollments_enrolled.push(enrollment)
                break
              case 'dropped':
                this.enrollments_enrolled.splice(this.enrollments_enrolled.indexOf(enrollment), 1)
                this.enrollments_completed.splice(this.enrollments_completed.indexOf(enrollment), 1)
                this.enrollments_skipped.splice(this.enrollments_skipped.indexOf(enrollment), 1)
                this.enrollments_attending.splice(this.enrollments_attending.indexOf(enrollment), 1)
                this.enrollments_dropped.push(enrollment)
                break
              case 'attending':
                this.enrollments_enrolled.splice(this.enrollments_enrolled.indexOf(enrollment), 1)
                this.enrollments_dropped.splice(this.enrollments_dropped.indexOf(enrollment), 1)
                this.enrollments_completed.splice(this.enrollments_completed.indexOf(enrollment), 1)
                this.enrollments_skipped.splice(this.enrollments_skipped.indexOf(enrollment), 1)
                this.enrollments_attending.push(enrollment)
                break
              case 'completed':
                this.enrollments_attending.splice(this.enrollments_attending.indexOf(enrollment), 1)
                this.enrollments_enrolled.splice(this.enrollments_enrolled.indexOf(enrollment), 1)
                this.enrollments_dropped.splice(this.enrollments_dropped.indexOf(enrollment), 1)
                this.enrollments_skipped.splice(this.enrollments_skipped.indexOf(enrollment), 1)
                this.enrollments_completed.push(enrollment)
                break
              case 'skipped':
                this.enrollments_enrolled.splice(this.enrollments_enrolled.indexOf(enrollment), 1)
                this.enrollments_dropped.splice(this.enrollments_dropped.indexOf(enrollment), 1)
                this.enrollments_completed.splice(this.enrollments_completed.indexOf(enrollment), 1)
                this.enrollments_attending.splice(this.enrollments_attending.indexOf(enrollment), 1)
                this.enrollments_skipped.push(enrollment)
                break
            }
          })
          .catch(error => this.setError(error, 'Cannot update group'))
      } else {
        this.notice = ''
        this.error = ''
      }
    },
    removeEnrollment (enrollment) {
      this.$http.secured.delete(`/manager/enrollments/${enrollment.id}`)
        .then(response => this.enrollments.splice(this.enrollments.indexOf(enrollment), 1))
        .catch(error => this.setError(error, 'Cannot delete enrollment'))
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
          this.$swal('Deleted', 'You successfully deleted this file', 'success')
          this.removeEnrollment(group)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  directives: {
    'enrollment-focus': function (el) {
      el.focus()
    }
  },
  components: { Manager, Datepicker }
}
</script>
