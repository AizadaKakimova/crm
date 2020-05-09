<!-- combined  -->
<template>
    <div class="groups col-md-10">
      <b-alert  v-if="error" show dismissible ariant="alert">
        {{ error }}
      </b-alert>
      <b-card class="card" header="Таймлайн групп">
        <div class="tabs">
                <div class="d-flex justify-content-end">
                    <button class="btn btn-outline-primary mb-3" v-for="(branch, index) in branches" :class="{active : currentTab === index}" @click="currentTab = index">{{ branch.name }}</button>
                </div>
            </div>
            <div class="tab-content">
              <div v-show="currentTab === 0">
                <GChart v-if="!loading" style="height: 500px;"
                  :settings="{packages: ['timeline']}"
                  type="Timeline"
                  :data="chartData"
                  :options="chartOptions"
                  @ready="onChartReady"
                />
                <h2 v-else>Error loading chart</h2>
              </div>
          </div>
          <div class="tab-content">
              <div v-show="currentTab === 1">
                <GChart v-if="!loading" style="height: 500px;"
                  :settings="{packages: ['timeline']}"
                  type="Timeline"
                  :data="chartData2"
                  :options="chartOptions"
                  @ready="onChartReady"
                />
                <h2 v-else>Error loading chart</h2>
              </div>
          </div>
      </b-card>
    </div>
</template>
<script>
import Admin from '@/components/layouts/admin/Admin'
import { GChart } from 'vue-google-charts'
import { PulseLoader } from 'vue-spinner/dist/vue-spinner.min.js'
export default {
  data () {
    return {
      chartsLib: null,
      chartData: [],
      chartData2: [],
      chartOptions: {
        timeline: { rowLabelStyle: {fontName: 'Gilroy', fontSize: 14, color: '#603913'},
          barLabelStyle: { fontName: 'Gilroy', fontSize: 14 } },
        backgroundColor: '#fff'
      },
      loading: true,
      error: '',
      users: {},
      courses: {},
      currentTab: 0,
      branches: []
    }
  },
  created () {
    this.$emit('update:layout', Admin)
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/groups`)
        .then(response => {
          this.groups = response.data.groups
          this.loading  = false
          this.courses = response.data.courses.reduce((acc, value) => {
            acc[value.id] = value
            return acc
          }, {})
          this.enrollments = response.data.enrollments
          for (var i = 0; i < this.groups.length; i++) {
            if(this.groups[i].branch_id===this.branches[0].id) {
              this.chartData.push([this.groups[i].title, this.courses[this.groups[i].course_id].title, new Date(this.groups[i].start), new Date(this.groups[i].end)])
            } else if (this.groups[i].branch_id===this.branches[1].id) {
              this.chartData2.push([this.groups[i].title, this.courses[this.groups[i].course_id].title, new Date(this.groups[i].start), new Date(this.groups[i].end)])
            }
          }
        })
        .catch(error => { this.setError(error, 'Что-то пошло не так') })
        this.$http.secured.get(`/${this.$store.getters.getCurrentCity.slug}/admin/branches`)
                .then(response => {
                this.branches = response.data.branches
        })      
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    onChartReady (chart, google) {
      this.chartsLib = google
    }
  },
  components: { Admin, GChart,PulseLoader }
}
</script>
