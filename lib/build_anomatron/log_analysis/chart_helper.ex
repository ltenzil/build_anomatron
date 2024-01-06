defmodule BuildAnomatron.LogAnalysis.ChartHelper do

  def chart_data(builds) do
    Enum.map(builds, fn(build) -> data_point(build) end)
    |> Jason.encode!
  end

  def to_mins(milliseconds) when is_binary(milliseconds) do
    String.to_integer(milliseconds)
    |> div(60000)
  end
  
  def to_mins(milliseconds) do
    milliseconds |> div(60000)
  end
  

  def data_point(build) do
    [to_mins(build.execution_time), to_mins(build.estimated_duration), "#{build.job_name}/#{build.job_number}", build.status]
  end

  # def data_point(build) do
  #   %{x: to_mins(build.execution_time), y: to_mins(build.estimated_duration), job: "#{build.job_name}/#{build.job_number}", status: build.status}
  # end

end
