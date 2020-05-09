<template>
<div class="light-font col-md-8">
  <nav aria-label="breadcrumb">
    <ol class="breadcrumb breadcrumb-dot">
      <li v-for="(breadcrumb, idx) in breadcrumbList" :key='idx' @click="routeTo(idx)" class="breadcrumb-item" :class="{ 'linked': !!breadcrumb.link}" aria-current="page">
        {{breadcrumb.name}}
      </li>
    </ol>
  </nav>
</div>
</template>

<script>
export default {
  name: 'Breadcrumb',
  data() {
    return {
      breadcrumbList: []
    }
  },
  mounted() {
    this.updateList()
  },
  watch: {
    '$route'() {
      this.updateList()
    }
  },
  methods: {
    routeTo(pRouteTo) {
      if (this.breadcrumbList[pRouteTo].link) {
        this.$router.push(this.breadcrumbList[pRouteTo].link)
      }
    },
    updateList() {
      this.breadcrumbList = this.$route.meta.breadcrumb
    }
  }
}
</script>

<style lang="css">
.light-font {
  margin-top: 5%;
}
.breadcrumb {
 background-color:   #f6f6f6 !important;
 }
.linked {
  color: #0000CD;
}
.linked:hover {
  text-decoration: underline;
  cursor:pointer;
}
.breadcrumb-dot .breadcrumb-item+.breadcrumb-item::before {
    content: "❭";
    color: #0000CD;

}
</style>
