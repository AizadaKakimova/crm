<template>
  <nav class="navbar rounded">
    <ul class="navbar">
      <li class="nav-item contacts">
        <router-link class="nav-link" to="/signin">contacts</router-link>
      </li>
    </ul>
  </nav>
</template>
<script>
export default {
  name: 'MainFooter'
}
</script>
<style lang="css" scoped>
  .footer {
    background-color: black;
  }

  .navbar {
    padding-right: 0;
    padding-left: 0;
  }

  .navbar a {
    cursor: pointer;
    color: #212529;
  }

  .navbar ul {
    list-style: none;
  }

  .navbar .sign-out {
    padding-right: 0;
  }

  .navbar .home {
    padding-left: 0;
  }
</style>
