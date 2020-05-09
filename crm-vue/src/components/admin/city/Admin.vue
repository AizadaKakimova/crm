<template>
    <div class="col-md-6 mx-auto">
        <b-card header="Новый админ"> 
            <b-alert  v-if="error" show dismissible ariant="alert">
                {{ error }}
            </b-alert>
            <b-alert  v-if="notice" show dismissible ariant="success">
                {{ notice }}
            </b-alert>
            <form class="form-app form-edit" @submit.prevent="addAdmin">
                <div class="form-group">
                    Имя: <input type="text" v-model="user.name" placeholder="Введите имя" class="form-control mr-sm-2"
                                id="input-icon-left" name="input-icon-left" required autocomplete="off"/>
                </div>
                <div class="form-group mt-3">
                    Телефон:
                    <input type="text" v-model="user.phone" placeholder="Введите телефон" class="form-control mr-sm-2"
                        id="input-icon-left" name="input-icon-left" required autocomplete="off"/>
                </div>
                <div class="form-group mt-3">
                    Почта:
                    <input type="text" v-model="user.email" placeholder="Введите почту" class="form-control mr-sm-2"
                        id="input-icon-left" name="input-icon-left" required autocomplete="off"/>
                </div>
                <div class="form-group row">
                    <div class="col-sm-10">
                    <button type="submit" class="btn btn-primary">Добавить</button>
                </div>
                </div>
            </form>
        </b-card>
    </div>
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'

export default {
    name: 'AdminNew',
    data () {
        return {
            branch: [],
            user: {
                name: '',
                phone: '',
                email: '',
                role: 'admin'
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
                })
                .catch(error => { this.setError(error, 'Что-то пошло не так') })
        } else {
            this.$router.replace('/')
        }
    },
    methods: {
         addAdmin () {
            this.$http.secured.post(`/${this.$store.getters.getCurrentCity.slug}/admin/user/new`, this.user)
                .then(response => { this.createSuccessful(response) })
                .catch(error => { this.setError(error, 'Пожалуйста, проверьте поля!') })
        },
        setError (error, text) {
            this.error = (error.response && error.response.data && error.response.data.error) || text
        },
        createSuccessful (response) {
            this.notice = 'Пользователь добавлен'
            this.error = ''
        },
        createFailed (error) {
            this.error = (error.response && error.response.data && error.response.data.error) || ''
            this.notice = ''
        }
    }
}
</script>