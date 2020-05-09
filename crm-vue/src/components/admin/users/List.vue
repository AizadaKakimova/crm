<template>
  <div class="row">
<div class="col-xs-12 col-md-12">
  <b-card class="card" header = "Таблица пользователей">
    <b-alert class="col-4 alert-danger" v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <b-alert  v-if="notice" show dismissible ariant="success">
      {{ notice }}
    </b-alert>
    <div class ="d-flex">
<!-- {{$store.state.currentUser}} -->
      <form class="form-inline">
        <input type="text" v-model="search" placeholder="Поиск..." aria-label="Search" class="form-control mr-sm-2" @keyup="getUsers()" required/>
      </form>
      <div class="input-group justify-content-end">
        <download-excel
        class   = "btn btn-default"
        :data   = "json_data">
        <font-awesome-icon :icon="['far', 'file-excel']" class="fa-md-sm iconExcel"/>
      </download-excel>
        <download-excel
          class   = "btn btn-default"
          :data   = "json_data"
          :fields = "json_fields"
          type    = "csv"
          name    = "filename.xls">

          <font-awesome-icon :icon="['fas', 'file-csv']" class="fa-md-sm iconExcel"/>

      </download-excel>
        <router-link to="/admin/user/new">
          <button class="btn btn-sm btn-primary">
             + Добавить
          </button>
        </router-link>
      </div>
    </div>
    <div class = "table-responsive table-hover mt-3" id="users">
      <div class="btn-group col-md-2">
        <vue-pagination  :pagination="pagination"
                   @paginate="getUsers()"
                   :offset="4">
        </vue-pagination>
      </div>
      <table class="table first-td-padding table-striped">
        <thead>
          <tr>
            <th>ID</th>
            <th>Имя</th>
            <th>Телефон</th>
            <th>Почта</th>
            <th>Роль</th>
            <th>Филиал</th>
            <th>Коммент</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id" :user="user" @dblclick="editUser(user)">
            <td>{{ user.id }}</td>
            <td>
              <router-link :to="`/admin/users/${user.id}`">
                {{ user.name }}
              </router-link>
            </td>
            <td><div v-show="user !== editedUser">
              {{ user.phone }}
            </div>
            <div v-show="user === editedUser"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input min="11"  v-request-focus v-model="user.phone" v-mask="'+#-(###)-###-##-##'"/>
            </div></td>
            <td v-if="showUsersLink(user)">
                <div v-show="user !== editedUser">
              {{ user.email }}
            </div>
            <div v-show="user === editedUser"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input v-request-focus v-model="user.email"/>
            </div>

            </td>
            <td v-else>
              {{ user.email }}
            </td>
            <td>
              <div v-show="user !== editedUser">
              <span v-if="user.role==='admin'">админ</span>
              <span v-if="user.role==='user'">пользователь</span>
              <span v-if="user.role==='instructor'">преподаватель</span>
            </div>
            <div v-show="user === editedUser"
                v-on:blur="user.editedUser=false; $emit('update')">
              <select v-model="user.role" v-request-focus
                      @keyup.enter="updateUser(user)" id="role" :key="user.role">
                <option v-for="role in roles" :value="user.role" :key="role">{{ role }}</option>

              </select>
            </div>
           </td>
           <td>{{user.branch_id}}</td>
            <td><div v-show="user !== editedUser">
              {{ user.comment }}
            </div>
            <div v-show="user === editedUser"
                v-on:blur="user.editedUser=false; $emit('update')">
              <input v-request-focus v-model="user.comment"/>
            </div></td>
            <td>
              <font-awesome-icon class="red" v-show="user !== editedUser" icon="trash" v-if="showUsersLink(user)" @click="alertDisplay(user)"/>
              <div v-show="user === editedUser" @click="updateUser(editedUser)">
                <button type="button" class="btn btn-sm btn-warning" name="button">Изменить</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </b-card>
</div>
</div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import Breadcrumb from '@/components/Breadcrumbs'
import Datepicker from 'vuejs-datepicker'
import VuePagination from '@/components/pagination/Pagination.vue'
import JsonExcel from 'vue-json-excel'

export default{
  name: 'UsersList',
  data () {
    return {
      json_fields: {
            'Name': 'name',
            'Phone': 'phone',
            'Email': 'email',
            'Role' : 'role'
            
        },
        json_data: [
            {
                'name': '',
                'phone': '',
                'email': '',
                'role': ''
            }
        ],
        json_meta: [
            [
                {
                    'key': 'charset',
                    'value': 'utf-8'
                }
            ]
        ],
      error: '',
      notice: '',
      search: '',
      user: {
        name: '',
        phone: '',
        email: '',
        birthdate: '',
        school: ''
      },
      users: [],
      start: '',
      end: '',
      roles: ['админ', 'преподаватель', 'пользователь'],
      editedUser: '',
      pagination: {
      }
    }
  },
  mounted () {
    this.getUsers()
  },
  created () {
    this.$emit('update:layout', Admin)
    this.getUsers()
    // alert(this.$store.state.currentUser.branch_id)
  },
  methods: {
    getUsers () {
      if (this.$store.state.signedIn && (this.$store.getters.isAdmin || this.$store.getters.isManager)) {
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users?page=${this.pagination.current_page}&search=${this.search}`)
          .then(response => {
            this.users = response.data.users
            this.pagination = response.data.pagination    
            // alert(this.users)        
            for(let i=0; i<this.users.length; i++) {
              this.json_data[i] = {}
              this.json_data[i] = this.users[i]
            }
            
          })
          .catch(error => { this.setError(error, 'Что-то пошло не так') })
      } else {
        this.$router.replace('/')
      }
    },
    editUser (user) {
      this.editedUser = user
    },
    updateUser (user) {
      this.editedUser = ''
      this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${user.id}`, {
        user: {
          role: user.role,
          email: user.email,
          phone: user.phone,
          comment: user.comment
        }
      })
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateSuccessful(response) {
      this.notice = 'Пользователь изменен!'
      this.error = ''
    },
    filterUsersByDate (user) {
      let range = true
      let isStart = (new Date(user.created_at) >= new Date(this.start))
      let isEnd = (new Date(user.created_at) <= new Date(this.end))
      if (this.start && this.end) {
        range = range && isStart && isEnd
      } else {
        if (this.start) {
          range = range && isStart
        } else if (this.end) {
          range = range && isEnd
        }
      }
      return range
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    showUsersLink (user) {
      return this.$store.getters.isAdmin && this.$store.getters.currentUserId !== user.id
    },
    removeUser (user) {
      this.$http.secured.delete(`/${this.$store.getters.getCurrentCity.slug}/admin/users/${user.id}`)
        .then(response => this.users.splice(this.users.indexOf(user), 1))
        .catch(error => this.setError(error, 'Невозможно удалить пользователя'))
      this.notice = 'Успешно удален ' + user.name
    },
    alertDisplay (user) {
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
          this.$swal('Deleted', 'Вы успешно удалили пользователя', 'success')
          this.removeUser(user)
        } else {
          this.$swal('', 'Ты отменил удаление', 'info')
        }
      })
    }
  },
  directives: {
    'request-focus': function (el) {
      el.focus()
    }
  },
  components: { Admin, Datepicker, Breadcrumb, VuePagination }
}
</script>

<style lang="css" scoped>
.btn{
  border-radius: 0!important;
}
.form-control{
  border-radius: 0!important;
}
.card{
  border-radius: 0!important;
}
#date{
  width: 18.7rem;
  height: 2.5rem;
}
#date2{
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
.table td {
  align-items: center;
  border-bottom: 1px solid #dee2e6;
  font-weight: 450;
}
.table th {
  border-top: 0px solid #dee2e6;
  color: grey;
  font-weight: 400;
}
.iconExcel {
  font-size: 1.2rem;
  color: green;
}
</style>
