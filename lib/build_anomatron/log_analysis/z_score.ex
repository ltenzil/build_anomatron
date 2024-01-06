defmodule BuildAnomatron.LogAnalysis.ZScore do


  def calculate_z_scores(builds) do
    exec_times = Enum.map(builds, & to_mins(&1.execution_time))
    est_durations = Enum.map(builds, & to_mins(&1.estimated_duration))

    mean_exec = Enum.sum(exec_times) / Enum.count(exec_times)
    std_dev_exec = calculate_std_dev(exec_times, mean_exec)

    Enum.map(builds, fn build ->
      z_score = (to_mins(build.execution_time) - to_mins(build.estimated_duration)) / std_dev_exec
      {build, z_score}
    end)
  end

  def collect_anomalies(z_scores, threshold) do
    Enum.filter(z_scores, fn {_build, z} -> abs(z) > threshold end) |> Enum.map(&elem(&1, 0))
  end

  def to_mins(""), do: 0
  def to_mins(milliseconds) do
    String.to_integer(milliseconds)
    |> div(60000)
  end

  defp calculate_std_dev(data, mean) do
    variance = Enum.sum(Enum.map(data, fn x -> :math.pow(x - mean, 2) end)) / Enum.count(data)
    :math.sqrt(variance)
  end

end
