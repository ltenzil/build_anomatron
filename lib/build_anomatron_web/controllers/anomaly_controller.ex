defmodule BuildAnomatronWeb.AnomalyController do

  use BuildAnomatronWeb, :controller


  def index(conn, _params) do
    # Sample data
    data = Enum.map(1..1000, fn _ -> {rand_uniform(), rand_uniform()} end)
    anomalies = Enum.filter(data, fn {x, y} -> is_anomaly(x, y) end)

    render(conn, "index.html", data: data, anomalies: anomalies)
  end


  def z_scores(conn, params) do
    builds = BuildAnomatron.LogAnalysis.search_logs(params) # Fetch Jenkins build data

    z_scores = BuildAnomatron.LogAnalysis.ZScore.calculate_z_scores(builds)
    IO.inspect List.first(z_scores)
    threshold = case params["threshold"] do
      "" -> 0.7
      nil -> 0.7
      _ -> String.to_float(params["threshold"])
    end
    anomalies = BuildAnomatron.LogAnalysis.ZScore.collect_anomalies(z_scores, threshold)
    # z_scores = calculate_z_scores(builds)
    # threshold = params["threshold"] || 1.5 # Define your threshold for anomaly
    # anomalies = Enum.filter(z_scores, fn {_build, z} -> abs(z) > threshold end) |> Enum.map(&elem(&1, 0))
    # IO.inspect Enum.count(builds -- anomalies)
    # IO.inspect Enum.count(anomalies)
    render(conn, "z_scores.html", builds: builds, regular_builds: (builds -- anomalies), anomalies: anomalies)
  end

  defp fetch_build_data do
    # Fetch or simulate Jenkins build data
    Enum.map(1..100, fn _ -> %{execution_time: rand_time(), estimated_duration: rand_time()} end)
  end

  defp rand_time do
    :rand.uniform(120) + 30 # Random duration between 30 to 150
  end

  defp calculate_z_scores(builds) do
    exec_times = Enum.map(builds, & String.to_integer(&1.execution_time))
    est_durations = Enum.map(builds, & String.to_integer(&1.estimated_duration))

    mean_exec = Enum.sum(exec_times) / Enum.count(exec_times)
    std_dev_exec = calculate_std_dev(exec_times, mean_exec)

    Enum.map(builds, fn build ->
      z_score = (String.to_integer(build.execution_time) - String.to_integer(build.estimated_duration)) / std_dev_exec
      {build, z_score}
    end)
  end

  defp calculate_std_dev(data, mean) do
    variance = Enum.sum(Enum.map(data, fn x -> :math.pow(x - mean, 2) end)) / Enum.count(data)
    :math.sqrt(variance)
  end

  defp rand_uniform() do
    :rand.uniform() * 100  # Random value between 0 and 100
  end

  defp is_anomaly(x, y) do
    # Define your anomaly condition
    (x + y > 12235) || (x * y > 1692)
  end




end
