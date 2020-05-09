<template>
  <div class="row">
    <div class="col-xs-12 col-md-12">
      <b-card class="card" header = "Todo">
  <div class="todos">
    <b-alert class="col-4 alert-danger" v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert  class="col-4" v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
  <div class="row">
    <div class="col-5 ml-5 card">
  <h5 style="color:red" class="mt-3"><b>Должно быть сделано</b></h5>
  <table class="table">
    <thead>
      <tr>
        <th>Название</th>
        <th>Дэдлайн</th>
        <th>Статус</th>
        <th>От/До</th>
        <th>Действия</th>
      </tr>
    </thead>
    <tbody>
    <tr v-if="todo.status=='New' || todo.status=='In process'" v-for="todo in todos" :key='todo.id' :request="todo" @dblclick="editTodo(todo)">
        <td>
          <div>
          {{ todo.title }}
        </div>
          
        </td>
        <td>
          <div v-show="todo != editedTodo">
            {{ todo.deadline | formatDate }}
          </div>
          <div v-show="todo == editedTodo"
            v-on:blur="todo.editedTodo=false; $emit('update')">
            <datepicker id="date3"
              v-model.lazy="todo.deadline">
          </datepicker>
        </div>
        </td>
        <td>
          <div v-show="todo != editedTodo">
          <span v-if="todo.status==='New'">новый</span>
          <span v-if="todo.status==='Done'">сделан</span>
          </div>
          <div v-show="todo == editedTodo">
            <select v-model="todo.status" v-todo-focus v-on:blur="todo.editedTodo=false; $emit('update')" >
              <option value="New">новый</option>
              <option value="Done">сделан</option>
            </select>
          </div>
        </td>
        <td>
          <div v-if="todo.todo_maker == todo.todo_sender">
            мой
          </div>
          <div v-if="todo.todo_maker != null">
            Добавлено {{ `от ${users[todo.todo_sender].name} для ${users[todo.todo_maker].name}` }}
          </div>
        </td>
        <td v-if="showTodosLink()">
        <font-awesome-icon class="red" icon="trash" @click="alertDisplay(todo)"  v-show="todo !== editedTodo"/>
                    <div v-show="todo === editedTodo" @click="updateTodo(editedTodo)">
                      <button type="button" class="btn btn-sm btn-warning " name="button">Изменить</button>
                      </div>
        </td>
    </tr>
    </tbody>
  </table>
</div>
<div class="col-5 ml-5 card">
  <h5 style="color:green" class="mt-3"><b>Сделано</b></h5>
  <table class="table">
    <thead>
      <tr>
        <th>Название</th>
        <th>Дэдлайн</th>
        <th>Статус</th>
        <th>От/До</th>
        <th>Действия</th>
      </tr>
    </thead>
    <tbody>
    <tr v-if="todo.status=='Done'" v-for="todo in todos" :key='todo.id' :request="todo" @dblclick="editTodo(todo)">
      <td>
        <div>
        {{ todo.title }}
      </div>
      </td>
      <td>
        <div v-show="todo != editedTodo">
          {{ todo.deadline | formatDate }}
        </div>
        <div class="form-group" v-show="todo == editedTodo"
          v-on:blur="todo.editedTodo=false; $emit('update')">
          <datepicker id="date3"
            v-model.lazy="todo.deadline">
        </datepicker>
      </div>
      </td>
      <td>
        <div v-show="todo != editedTodo">
        <span v-if="todo.status==='New'">новый</span>
          <span v-if="todo.status==='Done'">сделан</span>
        </div>
        <div class="form-group" v-show="todo == editedTodo">
          <select v-model="todo.status" v-todo-focus v-on:blur="todo.editedTodo=false; $emit('update')" class="form-control">
            <option value="New">новый</option>
              <option value="Done">сделан</option>
          </select>
        </div>
      </td>
      <td>
          <div v-if="todo.todo_maker == todo.todo_sender">
            мой
          </div>
        <div v-if="todo.todo_maker != null">
          Добавлено {{ `от ${users[todo.todo_sender].name} для ${users[todo.todo_maker].name}` }}
        </div>
      </td>
      <td v-if="showTodosLink()">
      <font-awesome-icon class="red" icon="trash" @click="alertDisplay(todo)"  v-show="todo !== editedTodo"/>
            <div v-show="todo === editedTodo" @click="updateTodo(editedTodo)">
              <button type="button" class="btn btn-sm btn-warning" name="button">Изменить</button>
              </div>
</td>
     </tr>
    </tbody>
  </table>
</div>
</div>
        <div class="row">
      <div class="card col-4 ml-5 mt-5 todos">
        <form @submit.prevent="addTodo" class="form-app mx-auto mt-5">
        <div class="form-group">
            <textarea class="form-control" name="text" placeholder="Что должно быть сделано?"autofocus autocomplete="off"
            v-model="todo_item.title" @keyup.enter="addTodo"/>
            <p>&nbsp;</p>
            <div>
              <datepicker required="required" v-model="todo_item.deadline" name="start" placeholder="Когда это должно быть сделано?" id="date"></datepicker>
            </div>
        <p>&nbsp;</p>
          <select class="form-control" v-model="todo_item.todo_maker">
            <option v-for="user in users" :value="user.id" :key="user"> {{ user.name }}</option>
          </select>
        <p>&nbsp;</p>
        <button type="submit" class="btn btn-primary mb-3">Создать toDo</button>
  </div>
        </form>
    </div></div>
</div>
</b-card>
</div>
</div>


</template>

<script>
import Admin from '@/components/layouts/admin/Admin'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'TodosList',
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
      resource_url: `/${this.$store.getters.getCurrentCity.slug}/admin/todos`
    }
  },

  created () {
    this.$emit('update:layout', Admin)
    this.checkSignedIn()
    this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/todos`)
      .then(response => {
        this.todos = response.data.todos.filter((todo) => {
          return parseInt(todo.todo_maker) === this.$store.getters.currentUserId || parseInt(todo.todo_sender) === this.$store.getters.currentUserId
        })
        this.users = response.data.users.reduce((acc, value) => {
          acc[value.id] = value
          return acc
        }, {})
      })
      .catch(error => this.setError(error, 'Что-то пошло не так'))
  },
  methods: {
    showTodosLink () {
      return this.$store.getters.isAdmin || this.$store.getters.isManager
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addTodo () {
      this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/todos/`, this.todo_item)
        .then(response => {
          this.createSuccessful(response)
          this.todos.unshift(this.todo_item)
        })
        .catch(error => this.setError(error, 'Невозможно создать todo'))
    },
    createSuccessful (response) {
      this.notice = 'ToDo создан'
      this.error = ''
    },
    /* eslint-disable camelcase */
    removeTodo (todo_item) {
      this.$http.secured.delete(`/${this.$store.getters.getCurrentCity.slug}/admin/todos/${todo_item.id}`)
        .then(response => {
          this.todos.splice(this.todos.indexOf(todo_item), 1)
        })
        .catch(error => this.setError(error, 'Невозможно удалить todo'))
    },
    editTodo (todo_item) {
      this.editedTodo = todo_item
    },
    updateTodo (todo_item) {
      if (this.editedTodo) {
        this.editedTodo = ''
        this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/todos/${todo_item.id}`, {
          todo: {
            title: todo_item.title,
            deadline: todo_item.deadline,
            status: todo_item.status,
            todo_maker: todo_item.todo_maker,
            todo_sender: todo_item.todo_sender
          }
        })
          .then(response => this.updateSuccessful(response))
          .catch(error => this.setError(error, 'Невозможно обновить todo'))
      } else {
        this.notice = ''
        this.error = ''
      }
    },
    updateSuccessful (todo_item) {
      this.notice = 'Успешно обновлено'
      this.error = ''
    },
    /* eslint-enable camelcase */
    checkSignedIn () {
      if (!(this.$store.state.signedIn && this.$store.getters.isAdmin)) {
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
          this.$swal('Deleted', 'Вы успешно удалили', 'success')
          this.removeTodo(todo)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  directives: {
    'todo-focus': function (el) {
      el.focus()
    }
  },
  components: { Admin, Datepicker }
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
#date{
  width: 18.7rem;
  height: 2.5rem;
}
#date:hover, #date2:hover{
  box-shadow: 2px 1px 18px #007bff;
}
.vdp-datepicker__calendar header .prev:after{
  border-right: 10px solid #007bff;
}
.vdp-datepicker__calendar header .next:after{
  border-left: 10px solid #007bff;
}
.vdp-datepicker__calendar .cell.day-header{
  color: #007bff;
}
td{
  font-size: 0.8rem;
}
th{
  font-size: 0.9rem;
}
.todos .form-app .form-group .form-control{
  width: 18.7rem;
}
</style>
