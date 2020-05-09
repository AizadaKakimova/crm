<template>
    <div class="col-md-6 mx-auto">
        <b-alert  v-if="error" show dismissible ariant="alert">
            {{ error }}
        </b-alert>
        <b-alert  v-if="notice" show dismissible ariant="success">
            {{ notice }}
        </b-alert>
        <b-card header="Новый Филиал">
            <form class="form-app form-edit" @submit.prevent="addBranch()">
                <div class="form-group">
                    Название: <input type="text" v-model="branch.name" autocomplete="off" class="form-control mr-sm-2" id="input-icon-left" name="input-icon-left" required/>
                </div>
                <div class="form-group mt-3" >
                    Адрес: <input type="text" v-model="branch.address" autocomplete="off" class="form-control mr-sm-2" id="input-icon-left" name="input-icon-left" required/>
                </div>
                <button type="submit" class="btn btn-primary mb-3">Создать</button>
                <div>
                    <router-link to="/admin/groups/">Назад к таблице Филиалов</router-link>
                </div>
            </form>
        </b-card>
    </div>
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'

export default {
    name: 'CityNew',
    data () {
        return {
            branch: {
                name: '',
                address: ''
            },
            notice: '',
            error: ''
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
        addBranch () {
            this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/branches/new`, this.branch)
                .then(response => { this.createSuccessful(response) })
                .catch(error => { this.setError(error, 'Пожалуйста, проверьте поля!') })
        },
        createSuccessful (response) {
            this.notice = 'Филиал добавлен'
            this.error = ''
        },
        createFailed (error) {
            this.error = (error.response && error.response.data && error.response.data.error) || ''
            this.notice = ''
        },
    }
}
</script>