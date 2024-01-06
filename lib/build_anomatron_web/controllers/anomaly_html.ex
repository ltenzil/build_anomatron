defmodule BuildAnomatronWeb.AnomalyHTML do
  use BuildAnomatronWeb, :html

  embed_templates "anomaly_html/*"

  def to_mins(milliseconds) do
    String.to_integer(milliseconds)
    |> div(60000)
  end

  def data_point(build, "regular") do
    [to_mins(build.execution_time), to_mins(build.estimated_duration), "#{build.job_name}/#{build.job_number}"]
  end

  def data_point(build, "anomalies") do
    %{x: to_mins(build.execution_time), y: to_mins(build.estimated_duration), name: "#{build.job_name}/#{build.job_number}"}
  end



end
