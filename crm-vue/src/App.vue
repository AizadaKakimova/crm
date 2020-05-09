<template>
  <component :is="layout">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <router-view :layout.sync="layout"/>
    </component>
</template>
<script>
import '@/assets/css/style.css'
import 'bootstrap-vue/dist/bootstrap-vue'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import 'bootstrap/dist/css/bootstrap.min.css'
import 'slick-carousel/slick/slick.css'
export default {
  data () {
    return {
      layout: 'div',
      img: '<img src="@/assets/images/python.png">'
    }
  }
}
</script>
