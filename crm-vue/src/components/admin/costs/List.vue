<template>
  <div>
    <div class = "row">
      <div class="col-4">
      <div class="alert alert-danger" v-if="error">{{ error }}</div>
        <b-alert  v-if="notice" show dismissible ariant="success">
           {{ notice }}
        </b-alert>
        <b-card header = "Расходы" class = "card">
          <form class="form-course" @submit.prevent="addCost">
            <div class="form-group">
              <input type='hidden' :model="cost.user_id = this.$store.getters.currentUserId">
            </div>
            <div class="form-group">
              <basic-select :options="listForSearch(costs)"
                            :selected-option="cost"
                            placeholder="Hints for costs"
                            @select="onSelect">
              </basic-select>
              <br/>
              <input class="form-control" type="name" name="" value="" v-model="cost.cost_name" placeholder="Название расхода">
            </div>
            <div class="form-group">
              <input class="form-control" type="number" placeholder="Сумма расхода"  v-model="cost.amount" name="" value="">
            </div>
            <div class="form-group">
              <select class="form-control" v-model="cost.fix">
                <option value='true'>Фиксированный</option>
                <option value='false'>Нефиксированный</option>
              </select>
            </div>
            <button type="submit" class="btn btn-primary mb-3">Создать</button>
          </form>
        </b-card>
      </div>

      <div class="col-md-7">
        <b-card class="card">
          <div  v-for="(item, index, i) in costs" :key="index">
          <b-btn block v-b-toggle="'' + i" variant="info">
            {{ index | formatDate }}
          </b-btn>
          <p>&nbsp;</p>
            <div class = "table-responsive table-hover mt-3">
            <b-collapse :id="'' + i">
              <table class="table first-td-padding">
                <thead>
                  <tr>
                    <th>Название расхода</th>
                    <th>Имя создателя   </th>
                    <th>Общяя сумма     </th>
                    <th>Тип расхода     </th>
                    <th>Действия         </th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="cost in item" :key="cost.id" :cost="cost" >
                    <td>
                      <router-link :to="`/admin/costs/${cost.id}`">
                        {{ cost.cost_name }}
                      </router-link>
                    </td>
                    <td> {{ findName(cost.user_id) }} </td>
                    <td> {{ cost.amount  }}           </td>
                    <td v-if="cost.fix"> Fixed        </td>
                    <td v-else> Not Fixed             </td>
                    <td>
                      <router-link :to="`/admin/costs/${cost.id}`">
                        <button type="primary" class="btn btn-outline-primary  my-2 my-sm-0" :v-b-modal="cost.id+'modal'">
                          <i class="far fa-edit">{{cost.id}}</i>
                        </button>
                      </router-link>
                      <button type="danger" class="btn btn-outline-danger  my-2 my-sm-0" @click="alertDisplay(cost)">
                        <font-awesome-icon icon="trash"/>
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </b-collapse>
            </div>
            </div>
          </b-card>
        </div>
      </div>
  </div>
</div>

</div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import { BasicSelect } from 'vue-search-select'

export default {
  name: 'CostsList',
  data () {
    return {
      error: '',
      notice: '',
      costs: [],
      index: [],
      searchText: '',
      cost: {
        id: '',
        cost_name: '',
        user_id: '',
        fix: '',
        amount: ''
      }
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/costs`)
        .then(response => {
          this.costs = response.data.costs
          this.names = response.data.names
          // console.log(this.listForSearch(this.costs))
        })
        .catch(error => { this.setError(error, 'Что-то пошло не так') })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    onSelect (cost) {
      this.cost = cost
    },
    reset () {
      this.cost = {}
    },
    selectFromParentComponent () {
      // select option from parent component
      this.cost = this.listForSearch(this.costs)[0].cost_name
    },
    listForSearch (costs) {
      var arrayIn = []
      var array = []
      var flag
      var obj = {value: '1', text: 'yext'}
      costs = Object.values(costs)
      for (var i = 0; i < costs.length; i++) {
        array = costs[i]
        for (var j = 0; j < array.length; j++) {
          flag = true
          for (var c = 0; c < arrayIn.length; c++) {
            if (arrayIn[c].cost_name === array[j].cost_name) {
              flag = false
            }
          }
          if (flag || arrayIn.length < 1) {
            obj = {value: j, text: array[j].cost_name, amount: array[j].amount, cost_name: array[j].cost_name, fix: array[j].fix}
            arrayIn.push(obj)
          }
        }
      }
      return arrayIn
    },
    findName (id) {
      for (var i = 0; i < this.names.length; i++) {
        if (this.names[i][0] === id) {
          return this.names[i][1]
        }
      }
      return 'user not found-_-'
    },
    addCost () {
      this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/costs/new`, this.cost)
        .then(response => {
          this.createSuccessful(response)
          this.update_data()
        })
        .catch(error => { this.setError(error, 'Пожалуйста, проверьте поля!') })
    },
    createSuccessful (response) {
      this.notice = 'Расходы добавлены'
      this.error = ''
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    removeCost (cost) {
      this.$http.secured.delete(`/admin/costs/${cost.id}`)
      // .then(response => this.costs.splice(this.costs.indexOf(cost), 1))
        .then(response => {
          this.update_data()
        })
        .catch(error => this.setError(error, 'Невозможно удалить расходы'))
        // this.update_data()
    },
    editCourse (course) {
      this.editedRequest = course
    },
    updateCourse (course) {
      this.editedRequest = ''
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/courses/${course.id}`)
        .catch(error => this.setError(error, 'Невозможно обновить курс'))
    },
    update_data () {
      this.$emit('update:layout', Admin)
      if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/costs`)
          .then(response => {
            this.costs = response.data.costs
            // this.listForSearch(this.costs)
          })
          .catch(error => { this.setError(error, 'Что-то пошло не так') })
      } else {
        this.$router.replace('/')
      }
    },
    alertDisplay (cost) {
      this.$swal({
        title: 'Вы уверены что хотите удалить курс?',
        type: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Да, удалить!',
        cancelButtonText: 'Нет, оставить!',
        showCloseButton: true,
        showLoaderOnConfirm: true
      }).then((result) => {
        if (result.value) {
          this.$swal('Deleted', 'Вы успешно удалили файл', 'success')
          this.removeCost(cost)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  components: { Admin, BasicSelect }
}
</script>
<style scoped>
.form-group, .form-control{
  width: 15rem!important;
}
</style>
