defmodule BuildAnomatronWeb.DashboardLive.Index do
  use Phoenix.LiveView
  import BuildAnomatron.LogAnalysis.ChartHelper

  @impl true
  def mount(params, _session, socket) do
     builds = load_builds(params)
     jobs = load_jobs(params)
     zscore_data = BuildAnomatronWeb.DashboardLive.ZScoreComponent.load_data(params)
    {:ok, assign(socket, search_query: "", data: load_data(), builds: builds,
     jobs: jobs, threshold: "0.7", regular_builds: zscore_data[:regular_builds], anomalies: zscore_data[:anomalies])}
  end

  def handle_event("build_status", %{"value" => ""} = params, socket) do
    {:noreply, socket }
  end

  def handle_event("job_name", %{"value" => ""} = params, socket) do
    {:noreply, socket }
  end

  @impl true
  def handle_event("build_status", %{"value" => query}, socket) do
    {:noreply, assign(socket, search_query: query, jobs: load_jobs(%{status: query}), builds: load_builds(%{status: query}))}
  end

  @impl true
  def handle_event("job_name", %{"value" => query}, socket) do
    {:noreply, assign(socket, search_query: query, jobs: load_jobs(%{job_name: query}), builds: load_builds(%{job_name: query}))}
  end

  # @impl true
  # def handle_event("job_name", %{"value" => query}, socket) do
  #   filtered_data = filter_data(query, load_data())
  #   {:noreply, assign(socket, search_query: query, data: filtered_data)}
  # end

  defp load_builds(status) do
    builds = BuildAnomatron.LogAnalysis.builds_by_status(status)
    pie_chart_data = Enum.map(builds, fn(build) ->
      %{y: build.count, name: build.status}
    end)
    pie_chart_data
  end

  defp load_jobs(job) do
    jobs = BuildAnomatron.LogAnalysis.load_jobs_with_status(job)
    # total_counts = Enum.map(jobs, & &1.count)
   %{
      categories: Enum.map(jobs, & &1.job_name),
      series: [
        %{name: "Success", data: Enum.map(jobs, & &1.success_count)},
        %{name: "Failure", data: Enum.map(jobs, & &1.failure_count)},
        %{name: "Error", data: Enum.map(jobs, & &1.error_count)},
        %{name: "Abort", data: Enum.map(jobs, & &1.abort_count)},
        %{name: "Unstable", data: Enum.map(jobs, & &1.unstable_count)}
      ]
    }
  end

  defp load_data do
    # Sample data
    [%{id: 1, name: "Chart 1", value: 10}, %{id: 2, name: "Chart 2", value: 20}, %{id: 3, name: "Chart 3", value: 30}]
  end

  defp filter_data(query, data) do
    Enum.filter(data, fn chart -> String.contains?(chart.name, query) end)
  end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Charts")
  #   |> assign(:dashboard, nil)
  # end

  # @impl true
  # def handle_info({BuildAnomatronWeb.DashboardLive.FormComponent, {:saved, dashboard}}, socket) do
  #   {:noreply, stream_insert(socket, :charts, dashboard)}
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   dashboard = Charts.get_dashboard!(id)
  #   {:ok, _} = Charts.delete_dashboard(dashboard)

  #   {:noreply, stream_delete(socket, :charts, dashboard)}
  # end

  def chart_options(data) do
    %{
      chart: %{ type: "pie" },
      title: %{ text: "Build Status" },
      series: [%{
          name: "Builds by Status",
          colorByPoint: true,
          data: data
      }]
    }
  end

  def bar_chart_options(data) do
    %{
      chart: %{ type: "bar" },
      title: %{ text: "Jobs Dashboard" },
      xAxis: %{
        categories: data[:categories],
        title: %{ text: "Job Name" }
      },
      yAxis: %{ title: %{ text: "Count" }},
      plotOptions: %{
        series: %{ stacking: "normal" }
      },
      series: data[:series]
    }
  end
end
