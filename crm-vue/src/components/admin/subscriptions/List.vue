<template>
<div class="col-md-10">
  <b-alert v-if="error" show dismissible ariant="alert">
    {{ error }}
  </b-alert>
  <b-alert v-if="notice" show dismissible ariant="success">
    {{ notice }}
  </b-alert>
  <div class="row">
    <div class="col-md-6">
      <h3>Subscriptions</h3>
      <table class="table table-striped table-hover">
        <thead>
          <tr>
            <th>Email</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="subscription in subscriptions" :key="subscription.id">
            <td>{{ subscription.email }}</td>
            <td>{{ subscription.created }}</td>
            <td>
              <font-awesome-icon icon="trash" class="danger" @click="alertDisplay(subscription)"></font-awesome-icon>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</div>
</div>
</div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'

export default {
  name: 'SubscriptionList',
  data() {
    return {
      error: '',
      notice: '',
      subscriptions: []
    }
  },
  created() {
    this.$emit('update:layout', Admin)
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get('/admin/subscriptions')
        .then(response => {
          this.subscriptions = response.data.subscriptions
        })
        .catch(error => {
          this.setError(error, 'Что-то пошло не так')
        })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    addCost() {
      this.$http.secured.post('/admin/costs/new', this.cost)
        .then(response => {
          this.createSuccessful(response)
          this.update_data()
        })
        .catch(error => {
          this.setError(error, 'Пожалуйста, проверьте поля!')
        })
    },
    createSuccessful(response) {
      this.notice = 'Cost Added'
      this.error = ''
    },
    setError(error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    removeCost(subscription) {
      this.$http.secured.delete(`/admin/subscriptions/${subscription.id}`)
        // .then(response => this.costs.splice(this.costs.indexOf(cost), 1))
        .then(response =>
          this.subscriptions.splice(this.subscriptions.indexOf(subscription), 1),
          this.notice = 'Successfully deleted subscription'
        )
        .catch(error => this.setError(error, 'Cannot subscription cost!'))
    },
    editCourse(course) {
      this.editedRequest = course
    },
    updateCourse(course) {
      this.editedRequest = ''
      this.$http.secured.patch(`/admin/courses/${course.id}`)
        .catch(error => this.setError(error, 'Cannot update Course'))
    },
    alertDisplay(subscription) {
      this.$swal({
        title: 'Вы уверены что хотите удалить почту?',
        type: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Да, удалить!',
        cancelButtonText: 'Нет, оставить!',
        showCloseButton: true,
        showLoaderOnConfirm: true
      }).then((result) => {
        if (result.value) {
          this.$swal('Deleted', 'You successfully deleted this file', 'success')
          this.removeCost(subscription)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  components: {
    Admin
  }
}
</script>
