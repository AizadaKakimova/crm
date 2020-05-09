<template>
<div class="admin">
  <AdminHeader></AdminHeader>
  <div class="row">
    <div class="col-md-2">
      <AdminSidebar></AdminSidebar>
    </div>
    <div class="col-md-10">
      <Breadcrumbs></Breadcrumbs>
      <div class="main">
        <slot></slot>
      </div>
    </div>
  </div>
  <AdminFooter></AdminFooter>
</div>
</template>
<script>
import AdminHeader from '@/components/layouts/admin/AdminHeader'
import AdminFooter from '@/components/layouts/admin/AdminFooter'
import AdminSidebar from '@/components/layouts/admin/AdminSidebar'
import Breadcrumbs from '@/components/Breadcrumbs'
export default {
  name: 'Admin',
  created() {
    if (!this.$store.state.signedIn) {
      this.$router.replace('/')
    } else {
      this.$parent.$emit('update:layout', this.name)
    }
  },
  render() {
    return this.$slots.default[0]
  },
  components: {
    AdminSidebar,
    AdminHeader,
    AdminFooter,
    Breadcrumbs
  }
}
</script>
<style lang="scss" scoped>
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
