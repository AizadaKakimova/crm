<!-- combined  -->
<template>
  <div class="groups col-md-10">
    <b-alert v-if="error" show dismissible ariant="alert">
      {{ error }}
    </b-alert>
    <h3>Groups Timeline</h3>
    <GChart v-if="!loading" style="height: 500px;"
            :settings="{packages: ['timeline']}"
            type="Timeline"
            :data="chartData"
            :options="chartOptions"
            @ready="onChartReady"
    />
    <h2 v-else>Error loading chart</h2>
  </div>
</template>
<script>
  import Manager from '@/components/layouts/manager/Manager'
  import {GChart} from 'vue-google-charts'

  export default {
    data() {
      return {
        chartsLib: null,
        chartData: [],
        chartOptions: {
          timeline: {
            rowLabelStyle: {fontName: 'Gilroy', fontSize: 14, color: '#603913'},
            barLabelStyle: {fontName: 'Gilroy', fontSize: 14}
          },
          backgroundColor: '#fff'
        },
        loading: true,
        error: '',
        users: {},
        courses: {},
      }
    },
    created() {
      this.$emit('update:layout', Manager)
      if (this.$store.state.signedIn && this.$store.getters.isManager) {
        this.$http.secured.get('/manager/groups')
          .then(response => {
            this.groups = response.data.groups
            this.courses = response.data.courses.reduce((acc, value) => {
              acc[value.id] = value
              return acc
            }, {})
            this.enrollments = response.data.enrollments
            for (var i = 0; i < this.groups.length; i++) {
              this.chartData.push([this.groups[i].title, this.courses[this.groups[i].course_id].title, new Date(this.groups[i].start), new Date(this.groups[i].end)])
            }
            this.loading = false
          })
          .catch(error => {
            this.setError(error, 'Something went wrong')
          })
      } else {
        this.$router.replace('/')
      }
    },
    methods: {
      onChartReady(chart, google) {
        this.chartsLib = google
      }
    },
    components: {Admin, GChart}
  }
</script>
