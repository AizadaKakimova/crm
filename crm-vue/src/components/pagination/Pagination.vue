<template>
<div class="pagination">
  <button type="button" class="btn btn-sm btn-outline-secondary" v-if="pagination.current_page !== 1" @click="changePage(pagination.current_page - 1)">
    назад
  </button>
  <button class="btn btn-sm btn-outline-secondary" v-for="page in pagesNumber" :key='page' @click="changePage(page)" v-if="Math.abs(page - pagination.current_page) < 3 || page == pagination.total_pages || page == 0" :class="{current: pagination.current_page === page, last: (page == pagination.total_pages && Math.abs(page - pagination.current_page) > 3),
      first:(page == 0 && Math.abs(page - pagination.current_page) > 3), active: page == pagination.current_page}">
    {{ page }}
  </button>
  <button class="btn btn-sm btn-outline-secondary" v-if="pagination.current_page < pagination.last_page" @click="changePage(pagination.current_page + 1)">
    вперед
  </button>
</div>
</template>
<script>
export default {
  props: {
    pagination: {
      type: Object,
      required: true
    },
    offset: {
      type: Number,
      default: 4
    }
  },
  computed: {
    pagesNumber () {
      if (!this.pagination.to) {
        return []
      }
      let from = this.pagination.current_page - this.offset
      if (from < 1) {
        from = 1
      }
      let to = from + (this.offset * 2)
      if (to >= this.pagination.last_page) {
        to = this.pagination.last_page
      }
      let pagesArray = []
      for (let page = from; page <= to; page++) {
        pagesArray.push(page)
      }
      return pagesArray
    }
  },
  methods: {
    changePage (page) {
      this.pagination.current_page = page
      this.$emit('paginate')
    }
  }
}
</script>
