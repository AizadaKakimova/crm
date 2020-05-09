<template>
  <div class="col-md-6 ml-auto mr-auto">
    <b-alert  v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert  v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <b-card header = "Edit cost" class="card">
      <table>
        <tr>
          <td>Название расхода:</td>
          <td v-show="cost!==editedCost" @dblclick="editCost(cost)">{{cost.cost_name}}</td>
          <td v-show="cost === editedCost"
                v-on:blur="cost.editedCost=false; $emit('update')">
              <input class="form-control" v-if="cost === editedCost" v-click-outside="update" v-request-focus v-model="cost.cost_name" @keyup.enter="update()" @focusout="focus(false)"/></td>
        </tr>
        <tr>
          <td>Сумма расхода:</td>
          <td v-show="cost!==editedCostAmount" @dblclick="editCostAmount(cost)">{{cost.amount}}</td>
          <td v-show="cost === editedCostAmount"
                v-on:blur="cost.editedCost=false; $emit('update')">
              <input class="form-control" v-if="cost === editedCostAmount" v-click-outside="update" v-request-focus v-model="cost.amount" @keyup.enter="update()" @focusout="focus(false)"/></td>
        </tr>
        <tr>
          <td>Fix:</td>
          <td v-show="cost!==editedCostFix" @dblclick="editCostFix(cost)">{{cost.fix}}</td>
          <td v-show="cost === editedCostFix"
                v-on:blur="cost.editedCost=false; $emit('update')">
                <select class="form-control" v-model="cost.fix">
                          <option value='true'>Fixed</option>
                          <option value='false'>Not fixed</option>
                        </select>
          </td>
        </tr>
      </table>
            <button type="submit" class="btn btn-primary mb-3" @click="update()">Обновить</button>
    <div>
        <router-link :to="`/admin/costs`">Назад к Расходам</router-link>
      </div>
    </b-card>
  </div>
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'

export default {
  name: 'CostEdit',
  data () {
    return {
      error: '',
      notice: '',
      costs: [],
      cost: {
        id: '',
        cost_name: '',
        user_name: '',
        fix: '',
        amount: ''
      },
      editedCost: '',
      editedCostAmount: '',
      editedCostFix: ''
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/costs/${this.$route.params.id}`)
        .then(response => {
          this.cost = response.data.cost
        })
        // this.$http.secured.get('/admin/costs')
        //   .then(response => {
        //     this.costs = response.data.costs})

        .catch(error => { this.setError(error, 'Ошибка') })
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/costs`)
        .then(response => {
          this.costs = response.data.costs.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
        })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    editCost (cost) {
      this.editedCostAmount = ''
      this.editedCostFix = ''
      this.editedCost = cost
    },
    editCostAmount (cost) {
      this.editedCost = ''
      this.editedCostFix = ''
      this.editedCostAmount = cost
    },
    editCostFix (cost) {
      this.editedCost = ''
      this.editedCostAmount = ''
      this.editedCostFix = cost
    },
    update () {
      this.editedCost = ''
      this.editedCostAmount = ''
      this.editedCostFix = ''
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/costs/${this.$route.params.id}`, this.cost)
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateSuccessful (response) {
      this.notice = 'Расходы обновлены'
      this.error = ''
    },
    updateFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    }
  },
  directives: {
    'enrollment-focus': function (el) {
      el.focus()
    },
    'click-outside': {
        bind: function (el, binding, vNode) {
          // Provided expression must evaluate to a function.
          if (typeof binding.value !== 'function') {
            const compName = vNode.context.name
            let warn = `[Vue-click-outside:] provided expression '${binding.expression}' is not a function, but has to be`
            if (compName) {
              warn += `Found in component '${compName}'`
            }

            console.warn(warn)
          }
          // Define Handler and cache it on the element
          const bubble = binding.modifiers.bubble
          const handler = (e) => {
            if (bubble || (!el.contains(e.target) && el !== e.target)) {
              binding.value(e)
            }
          }
          el.__vueClickOutside__ = handler

          // add Event Listeners
          document.addEventListener('click', handler)
        },

        unbind: function (el, binding) {
          // Remove Event Listeners
          document.removeEventListener('click', el.__vueClickOutside__)
          el.__vueClickOutside__ = null

        }
      }
  },
  components: { Admin }
}
</script>
