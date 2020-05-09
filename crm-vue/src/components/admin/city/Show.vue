<template>
    <div class="col-md-10">
        <b-card header="Филиал">
            {{branch.name}}
        </b-card>
    </div>
</template>

<script>
import Admin from '@/components/layouts/admin/Admin'

export default {
    name: 'CityShow',
    data () {
        return {
            branch: {
                name: ''
            }
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
            this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/users`)
                .then(response => {
                    this.users = response.data.users
                })
            this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/branches/${this.$route.params.id}`)
                .then(response => {
                    this.branch = response.data.branch
                })
        } else {
            this.$router.replace('/')
        }
    }
}
</script>