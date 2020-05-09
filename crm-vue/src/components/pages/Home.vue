<template :key="this.currentCity">
  <div>
        <meta content="Курсы программирования для детей, школьников, студентов и взрослых. Научитесь программировать игры, сайты и приложения с нуля. Программирование с нуля." name="description">
    

  </div>
</template>
<script>
import Main from '@/components/layouts/Main'
export default {
  name: 'Home',
  data () {
    return {
      currentCity: {}
    }
  },
  mounted () {
    if (this.$store.state.currentCity==='') {
     this.$refs['my-modal'].show()
    }
  },
  data2: function () {
    return {menu: []}
  },
  components: {Main},
  created () {
    this.$emit('update:layout', Main)
  },
  props: {
    value: Boolean
  }
}
</script>
<style scoped lang='scss'>
@import '../../../src/assets/css/method.css';
@import '../../../src/assets/css/style.css';
  .dropdown-toggle {
  background-color: transparent;
  font-size: 0.75rem;
  font-family: 'Gilroy', serif;
  color: #fff;
  border: 0;
}
.nav-item .nav-link {
  color: #fff;
  font-size: 0.75rem;
  font-family: 'Gilroy', serif;
}
.logoM{
  filter: brightness(100%);
}
.icon2{
  color: #fff;
}
</style>
