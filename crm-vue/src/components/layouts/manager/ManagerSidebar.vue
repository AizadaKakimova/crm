<template>
  <div class="sidebar">
    <ul>
      <li>
        <router-link to="/manager/dashboard">Dashboard</router-link>
      </li>
      <li>
        <router-link to="/manager/users">Users</router-link>
      </li>
      <li>
        <router-link to="/manager/requests">Requests</router-link>
      </li>
      <li>
        <router-link to="/manager/courses">Courses</router-link>
      </li>
      <li>
        <router-link to="/manager/timeline">Timeline</router-link>
      </li>
      <li>
        <router-link to="/manager/groups">Groups</router-link>
      </li>
      <li>
        <router-link to="/manager/todos">Todos</router-link>
      </li>
    </ul>
  </div>
</template>
<script>
export default {
  name: 'Sidebar'
}
</script>
<style lang="css" scoped>
  .sidebar {
    height: 100vh;
  }
</style>
