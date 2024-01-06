defmodule BuildAnomatronWeb.DashboardLive.RandomForestLive do

  use Phoenix.LiveView
  import BuildAnomatron.LogAnalysis.ChartHelper

  @impl true
  def mount(params, _session, socket) do
    data = BuildAnomatron.LogAnalysis.random_forest_data()
    anomaly_data_ids = detect_anomalies(data)
    anomaly_builds = Enum.filter(data, fn(job) -> Enum.member?(anomaly_data_ids, job[:id]) end)
    regular_builds = data -- anomaly_builds
    {:ok, assign(socket, random_threshold: "status",  regular_builds: regular_builds, anomaly_builds: anomaly_builds)}
  end


  defp detect_anomalies(data, label \\ "status") do
    LogAnalysis.AnomalyDetector.detect_with_random(data, label)
    |> Enum.map(fn(record)-> record["id"] end)
  end

  def handle_event("random_threshold", %{"value" => ""} = params, socket) do
    {:noreply, socket }
  end
  
  def handle_event("random_threshold", %{"value" => value} = params, socket) do
    data = BuildAnomatron.LogAnalysis.random_forest_data()
    anomaly_data_ids = detect_anomalies(data, value)
    anomaly_builds = Enum.filter(data, fn(job) -> Enum.member?(anomaly_data_ids, job[:id]) end)
    regular_builds = data -- anomaly_builds
    {:noreply, assign(socket, random_threshold: value, regular_builds: regular_builds, anomaly_builds: anomaly_builds)}
  end


end
