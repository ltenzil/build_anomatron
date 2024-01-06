// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"


let Hooks = {};

Hooks.HighchartsHook = {
  mounted() {
    this.renderChart();
  },
  updated() {
    this.renderChart();
  },
  renderChart() {
    let chartOptions = JSON.parse(this.el.dataset.chartOptions);
    Highcharts.chart(this.el.id, chartOptions)
    // Highcharts.chart(this.el.id, {
    //   // Your Highcharts options here
    //   chart: { type: 'pie' }, // Example: For a pie chart
    //   series: [{ data: this.el.dataset.chartData }]
    // });
  }
};

Hooks.ZScoreChartHook = {
  mounted() {
    this.renderChart();
  },
  updated() {
    this.renderChart();
  },
  renderChart() {
    let anomalies = JSON.parse(this.el.dataset.anomalies)
    let regular_builds = JSON.parse(this.el.dataset.regularBuilds)
    let chart_title = this.el.dataset.chartTitle
    Highcharts.chart(this.el.id, {
      chart: {
        type: 'scatter',
        zoomType: 'xy'
      },
      title: {
        text: chart_title
      },      
      tooltip:{
        formatter: function() {
          return `
            exe_time: ${this.x},
            est_duration: ${this.y},
            job: ${this.point.job},
            status: ${this.point.status}
          `
        }
      },
      xAxis: {
        title: {
          text: 'Execution Time (minutes)'
        }
      },
      yAxis: {
        title: {
          text: 'Estimated Duration (minutes)'
        }
      },

      series: [{
          name: 'Regular Builds' + ':' + regular_builds.length,
          color: 'rgba(119, 152, 191, .5)',
          keys: ['x', 'y', 'job', 'status'],
          data: regular_builds
        },{
          name: 'Anomalies'  + ':' + anomalies.length,
          color: 'rgba(223, 83, 83, .5)',
          keys: ['x', 'y', 'job', 'status'],
          data: anomalies
      }]
    })
  }
};

// Connect your hooks to LiveSocket
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: {_csrf_token: csrfToken} });


// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

