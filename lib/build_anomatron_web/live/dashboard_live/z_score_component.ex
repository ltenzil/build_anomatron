defmodule BuildAnomatronWeb.DashboardLive.ZScoreComponent do

  use Phoenix.LiveComponent
  import BuildAnomatron.LogAnalysis.ChartHelper

  @impl true
  def mount(params, _session, socket) do
    data = load_data(params)
    {:ok, assign(socket, threshold: "0.7", regular_builds: data[:regular_builds], anomalies: data[:anomalies])}
  end

  def handle_event("filter_by_threshold", %{"value" => ""} = params, socket) do
    {:noreply, socket }
  end

  def handle_event("filter_by_threshold", %{"value" => nil} = params, socket) do
    {:noreply, socket }
  end

  def handle_event("filter_by_threshold", %{"value" => "0."} = params, socket) do
    {:noreply, socket }
  end


  @impl true
  def handle_event("filter_by_threshold", params, socket) do
    data = load_data(params)
    {:noreply, assign(socket, threshold: params["value"], regular_builds: data[:regular_builds], anomalies: data[:anomalies])}
  end

  def load_data(params) do
    builds = BuildAnomatron.LogAnalysis.search_logs(params) # Fetch Jenkins build data
    z_scores = BuildAnomatron.LogAnalysis.ZScore.calculate_z_scores(builds)
    threshold = case params["value"] do
      "" -> 0.7
      nil -> 0.7
      _ -> String.to_float(params["value"])
    end
    anomalies = BuildAnomatron.LogAnalysis.ZScore.collect_anomalies(z_scores, threshold)
    %{regular_builds: builds -- anomalies, anomalies: anomalies}
  end

end
