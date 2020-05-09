<template>
    <div>
        <div class="col-md-10">
            <b-card header="Филиалы">
                <router-link to="/admin/cities/new">
                    <button class="btn btn-primary">
                        <font-awesome-icon icon="plus-square"/> Добавить филиал
                    </button>
                </router-link>
                <router-link to="/admin/cities/admin/new">
                    <button class="btn btn-success">
                        <font-awesome-icon icon="plus-square"/> Добавить админа
                    </button>
                </router-link>
                <div class = "table-responsive table-hover table-striped">
                    <table class="table first-td-padding">
                        <tr>
                            <th>ID</th>
                            <th>Название</th>
                            <th>Адрес</th>
                            <th>Действия</th>
                        </tr>
                        <tr v-for="branch in branches" @dblclick="editBranch(branch)">
                            <td>{{branch.id}}</td>
                            <td>
                                <div v-show="branch !== editedBranch">
                                    <router-link :to="`/admin/cities/${branch.id}`">{{branch.name}}</router-link>
                                </div>
                                <div v-show="branch === editedBranch" v-on:blur="branch.editedBranch=false; $emit('update')">
                                    <input v-model="branch.name"/>
                                </div>
                            </td>
                            <td>
                                <div v-show="branch !== editedBranch">{{branch.address}}</div>
                                <div v-show="branch === editedBranch" v-on:blur="branch.editedBranch=false; $emit('update')">
                                    <input v-model="branch.address"/>
                                </div>
                            </td>
                            <td>
                                <div v-show="branch !== editedBranch">
                                    <font-awesome-icon icon="trash" class="red" @click="alertDisplay(branch)"/>
                                </div>
                                <div v-show="branch === editedBranch" @click="updateBranch(editedBranch)">
                                    <button type="button" class="btn btn-sm btn-warning" name="button">Изменить</button>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </b-card>
        </div>
    </div>
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'
export default {
    name: 'CityList',
    data () {
        return {
            branches: {
                id: '',
                name: '',
                address: ''
            },
            editedBranch: ''
        }
    },
    created () {
        this.$emit('update:layout', Admin)
        if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
            this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/branches`)
                .then(response => {
                this.branches = response.data.branches
                // console.log(this.listForSearch(this.costs))
                })
                .catch(error => { this.setError(error, 'Что-то пошло не так') })
        } else {
            this.$router.replace('/')
        }
    },
    methods: {
        alertDisplay (branch) {
          this.$swal({
            title: 'Вы уверены что хотите удалить филиал?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Да, удалить!',
            cancelButtonText: 'Нет, оставить!',
            showCloseButton: true,
            showLoaderOnConfirm: true
            }).then((result) => {
                if (result.value) {
                    this.$swal('Deleted', 'Вы успешно удалили филиал', 'success')
                    this.removeBranch(branch)
                } else {
                    this.$swal('', 'Ты отменил удаление', 'info')
                }
            })
        },
        removeBranch (branch) {
            this.$http.secured.delete(`/${this.$store.getters.getCurrentCity.slug}/admin/branches/${branch.id}`)
                .then(response => this.branches.splice(this.branches.indexOf(branch), 1))
                .catch(error => this.setError(error, 'Невозможно удалить курс'))
        },
        editBranch (branch) {
            this.editedBranch = branch
        },
         updateBranch (branch) {
            this.editedBranch = ''
            this.$http.secured.patch(`/${this.$store.getters.getCurrentCity.slug}/admin/branches/${branch.id}`, branch)
                .then(response => this.updateSuccessful(response))
                .catch(error => this.setError(error, 'Невозможно обновить филиал'))
        },
        updateSuccessful (response) {
            this.notice = 'Филиал обновлен'
            this.error = ''
        }
    } 
}
</script>