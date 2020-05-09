<template>
  <div class="manager">
    <Header></Header>
    <div class="row">
      <Sidebar class="col-md-2"></Sidebar>
      <slot class="col-md-12"></slot>
    </div>
    <MainFooter></MainFooter>
  </div>
</template>
<script>
import Header from '@/components/layouts/manager/ManagerHeader'
import MainFooter from '@/components/layouts/manager/ManagerFooter'
import Sidebar from '@/components/layouts/manager/ManagerSidebar'

export default {
  name: 'Manager',
  created () {
    if (!this.$store.state.signedIn) {
      this.$router.replace('/')
    } else {
      this.$parent.$emit('update:layout', this.name)
    }
  },
  render () {
    return this.$slots.default[0]
  },
  components: {MainFooter, Header, Sidebar}
}
</script>

<style lang="css">

</style>
