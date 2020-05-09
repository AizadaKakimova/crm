<template>
  <div>
    <MainHeader></MainHeader>
    <slot></slot>
    <MainFooter></MainFooter>
  </div>
</template>
<script>
import MainHeader from '@/components/MainHeader'
import MainFooter from '@/components/MainFooter'
export default {
  name: 'Main',
  created () {
    this.$parent.$emit('update:layout', this.name)
  },
  components: {MainFooter, MainHeader}
}
import '../../../src/assets/css/method.css';
import '../../../src/assets/css/style.css';
import 'vue2-animate/dist/vue2-animate.min.css';
</script>
