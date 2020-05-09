<template>
<div class="admin">
  <Header></Header>
  <div class="row">
    <div class="col-md-2">
      <Sidebar></Sidebar>
    </div>
    <div class="col-md-10">
      <Breadcrumbs></Breadcrumbs>
      <div class="main">
        <slot></slot>
      </div>
    </div>
  </div>
</div>
</template>
<script>
import Header from '@/components/layouts/student/StudentHeader.vue'
import Sidebar from '@/components/layouts/student/StudentSidebar.vue'
import Breadcrumbs from '@/components/Breadcrumbs'


export default {
  name: 'Student',
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
  components: {Header, Sidebar, Breadcrumbs}
}
</script>

<style lang="css" scoped>
.main {
    min-height: 100vh;
}
.admin{
  background-color: #f6f6f6;
}

table {
    font-size: 14px;
}
</style>
