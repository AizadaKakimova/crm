<script>
  import { Doughnut, mixins } from "vue-chartjs"
  const { reactiveProp } = mixins
export default {
  mixins: [reactiveProp],
  extends: Doughnut,
  props: ["data", "options"],
  mounted() {
    // this.chartData is created in the mixin.
    // If you want to pass options please create a local options object
    this.renderChart(this.chartData, {
      borderWidth: "10px",
      hoverBackgroundColor: "red",
      hoverBorderWidth: "10px"
    })
  }
}

</script>
