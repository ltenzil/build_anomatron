defmodule BuildAnomatronWeb.DashboardLive.IsolationForestLive do

  use Phoenix.LiveView
  import BuildAnomatron.LogAnalysis.ChartHelper

  @impl true
  def mount(params, _session, socket) do
    anomaly_data = detect_anomalies(params)
    regular_ids = Enum.filter(anomaly_data, fn(job) -> job["anomaly"] == 1 end) |> Enum.map(fn(job) -> job["id"] end)
    anomaly_ids = Enum.filter(anomaly_data, fn(job) -> job["anomaly"] == -1 end) |> Enum.map(fn(job) -> job["id"] end)
    regular_builds = BuildAnomatron.LogAnalysis.logs_by_ids(regular_ids)
    anomaly_builds = BuildAnomatron.LogAnalysis.logs_by_ids(anomaly_ids)
    {:ok, assign(socket, search_query: "",  regular_builds: regular_builds, anomaly_builds: anomaly_builds, threshold: "0.7")}
  end


  defp detect_anomalies(params) do
    BuildAnomatron.LogAnalysis.all_data()
    |> LogAnalysis.AnomalyDetector.detect_with_isolation_forest()
  end

end
