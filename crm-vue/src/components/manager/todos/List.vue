<template>
<div class="todos col-md-10">
  <b-alert v-if="error" show dismissible ariant="alert">
    {{ error }}
  </b-alert>
  <b-alert v-if="notice" show dismissible ariant="success">
    {{ notice }}
  </b-alert>
  <div class="row">
    <div class="todos col-md-5">
      <h3>Todos</h3>
      <form @submit.prevent="addTodo">
        <input class="form-control" autofocus autocomplete="off" placeholder="What needs to be done?" v-model="todo_item.title" @keyup.enter="addTodo" />
        <p>&nbsp;</p>
        <div>
          <datepicker required="required" v-model="todo_item.deadline" placeholder="When it needs to be done?"></datepicker>
        </div>
        <p>&nbsp;</p>
        <select class="form-control" v-model="todo_item.todo_maker">
          <option v-for="user in users" :value="user.id" :key='user.id'> {{ user.name }}</option>
        </select>
        <p>&nbsp;</p>
        <button type="submit" class="btn btn-primary mb-3">Create toDo</button>
      </form>
      <div class="todos col-md-7" @click="updateTodo(editedTodo)">
      </div>
    </div>
  </div>
  <h5 style="color:red"><b>Needs to be done</b></h5>
  <table class="table">
    <thead>
      <tr>
        <th>Title</th>
        <th>Deadline</th>
        <th>Status</th>
        <th>To/From</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <tr v-if="todo.status=='New' || todo.status=='In process'" v-for="todo in todos" :key='todo.id' :request="todo" @dblclick="editTodo(todo)" v-bind:class="{new:todo.status == 'New', process:todo.status == 'In process'}">
        <td>
          <div v-show="todo != editedTodo">
            {{ todo.title }}
          </div>
          <div class="form-group" v-show="todo == editedTodo" v-on:blur="todo.editedTodo=false; $emit('update')">
            <input v-model.lazy="todo.title" class="form-control">
          </div>
        </td>
        <td>
          <div v-show="todo != editedTodo">
            {{ todo.deadline | formatDate }}
          </div>
          <div class="form-group" v-show="todo == editedTodo" v-on:blur="todo.editedTodo=false; $emit('update')">
            <datepicker class="form-control" v-model.lazy="todo.deadline">
            </datepicker>
          </div>
        </td>
        <td>
          <div v-show="todo != editedTodo">
            {{ todo.status }}
          </div>
          <div class="form-group" v-show="todo == editedTodo">
            <select v-model="todo.status" v-todo-focus v-on:blur="todo.editedTodo=false; $emit('update')" class="form-control">
              <option>New</option>
              <option>In process</option>
              <option>Done</option>
            </select>
          </div>
        </td>
        <td>
          <div v-if="todo.todo_maker == todo.todo_sender">
            mine
          </div>
          <div v-else>
            added {{ `from ${users[todo.todo_sender].name} to ${users[todo.todo_maker].name}` }}
          </div>
        </td>
        <td>
        </td>
        <td v-if="showTodosLink()">
          <div v-show="todo === editedTodo" @click="updateTodo(todo)">
            <i class="btn btn-primary mb-3">Edit</i>
          </div>
        </td>
        <td>
          <i class="fa fa-trash-alt float-right btn btn-sm btn-danger" @click="alertDisplay(todo)"></i>
        </td>
      </tr>
    </tbody>
  </table>
  <h5 style="color:green"><b>Done</b></h5>
  <table class="table">
    <thead>
      <tr>
        <th>Title</th>
        <th>Deadline</th>
        <th>Status</th>
        <th>To/From</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
    <tr v-if="todo.status=='Done'" v-for="todo in todos" :key='todo.id' :request="todo" @dblclick="editTodo(todo)" v-bind:class="{done:todo.status=='Done'}">
      <td>
        <div v-show="todo != editedTodo">
        {{ todo.title }}
      </div>
        <div class="form-group" v-show="todo == editedTodo" v-on:blur="todo.editedTodo=false; $emit('update')">
        <input v-model.lazy="todo.title" class="form-control">
      </div>
      </td>
      <td>
        <div v-show="todo != editedTodo">
          {{ todo.deadline | formatDate }}
        </div>
        <div class="form-group" v-show="todo == editedTodo"
          v-on:blur="todo.editedTodo=false; $emit('update')">
          <datepicker class="form-control"
            v-model.lazy="todo.deadline">
        </datepicker>
      </div>
      </td>
      <td>
        <div v-show="todo != editedTodo">
        {{ todo.status }}
        </div>
        <div class="form-group" v-show="todo == editedTodo">
          <select v-model="todo.status" v-todo-focus v-on:blur="todo.editedTodo=false; $emit('update')" class="form-control">
            <option>New</option>
            <option>In process</option>
            <option>Done</option>
          </select>
        </div>
      </td>
      <td>
        <div v-if="todo.todo_maker == todo.todo_sender">
          mine
        </div>
      <div v-if="todo.todo_maker != null">
        added {{ `from ${users[todo.todo_sender].name} to ${users[todo.todo_maker].name}` }}
      </div>
      </td>
      <td>
      </td>
      <td v-if="showTodosLink()">
        <div v-show="todo === editedTodo" @click="updateTodo(todo)">
          <i class="btn btn-primary mb-3">Edit</i>
        </div>
      </td>
      <td>
        <i class="fa fa-trash-alt float-right btn btn-sm btn-danger" @click="alertDisplay(todo)"></i>
       </td>
     </tr>
    </tbody>
  </table>
</div>
</template>

<script>
import Manager from '@/components/layouts/manager/Manager'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'ManagerTodosList',
  data () {
    return {
      error: '',
      notice: '',
      todo_item: {
        title: '',
        deadline: '',
        status: 'New',
        todo_maker: this.$store.getters.currentUserId,
        todo_sender: this.$store.getters.currentUserId
      },
      user: {
        name: ''
      },
      users: [],
      todos: '',
      editedTodo: '',
      resource_url: '/manager/todos'
    }
  },

  created () {
    this.$emit('update:layout', Manager)
    this.checkSignedIn()
    this.$http.secured.get('/manager/todos')
      .then(response => {
        this.todos = response.data.todos.filter((todo) => {
          return parseInt(todo.todo_maker) === this.$store.getters.currentUserId || parseInt(todo.todo_sender) === this.$store.getters.currentUserId
        })
        this.users = response.data.users.reduce((acc, value) => {
          acc[value.id] = value
          return acc
        }, {})
      })
      .catch(error => this.setError(error, 'Something went wrong'))
  },
  methods: {
    showTodosLink () {
      return this.$store.getters.isAdmin || this.$store.getters.isManager
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addTodo () {
      this.$http.secured.post('/manager/todos/', this.todo_item)
        .then(response => {
          this.createSuccessful(response)
          this.todos.unshift(this.todo_item)
        })
        .catch(error => this.setError(error, 'Cannot create todo'))
    },
    createSuccessful (response) {
      this.notice = 'ToDo created'
      this.error = ''
    },
    /* eslint-disable camelcase */
    removeTodo (todo_item) {
      this.$http.secured.delete(`/admin/todos/${todo_item.id}`)
        .then(response => {
          this.todos.splice(this.todos.indexOf(todo_item), 1)
        })
        .catch(error => this.setError(error, 'Cannot delete todo'))
    },
    editTodo (todo_item) {
      this.editedTodo = todo_item
    },
    updateTodo (todo_item) {
      if (this.editedTodo) {
        this.editedTodo = ''
        this.$http.secured.patch(`/manager/todos/${todo_item.id}`, {
            todo: {
              title: todo_item.title,
              deadline: todo_item.deadline,
              status: todo_item.status,
              todo_maker: todo_item.todo_maker,
              todo_sender: todo_item.todo_sender
            }
          })
          .then(response => this.updateSuccessful(response))
          .catch(error => this.setError(error, 'Cannot update todo'))
      } else {
        this.notice = ''
        this.error = ''
      }
    },
    updateSuccessful (todo_item) {
      this.notice = 'Update successful'
      this.error = ''
    },
    /* eslint-enable camelcase */
    checkSignedIn () {
      if (!(this.$store.state.signedIn && this.$store.getters.isManager)) {
        this.$router.replace('/')
      }
    },
    alertDisplay (todo) {
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
          this.removeTodo(todo)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  directives: {
    'todo-focus': function(el) {
      el.focus()
    }
  },
  components: {
    Manager,
    Datepicker
  }
}
</script>

<style lang="css" scoped>
.todos ul li i.fa.fa-trash-alt {
  visibility: hidden;
  margin-top: 5px;
}
.todos ul li:hover {
  background: #fcfcfc;
}
.todos ul li:hover i.fa.fa-trash-alt {
  visibility: visible;
}
.new  {
  background: #A9C8C0;
}
.done  {
  background: #01796F;
}
.process  {
  background: lightgrey;
}
.datepicker1 {
max-width: 130px;
margin-left: -30px;
height: 38px;
}
</style>
