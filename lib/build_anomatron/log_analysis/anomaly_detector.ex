defmodule LogAnalysis.AnomalyDetector do
  def detect_with_isolation_forest(data) do
    json_data = Jason.encode!(data)
    {result, _} = System.cmd("python3", ["scripts/isolation_forest_predict.py", json_data])
    parse_result(result, data)
  end

  def detect_with_random_forest(data) do
    json_data = Jason.encode!(data)
    
    {result, _} = System.cmd("python3", ["scripts/random_forest_predict.py", json_data])
    parse_result(result, "")
  end

  def detect_with_random(data, label \\ "status") do
    json_data = Jason.encode!(data)
    input_label = case label do
      "status" -> "status"
      "time" -> "time"
      _ -> "status"
    end
    {result, _} = System.cmd("python3", ["scripts/random_predict.py", json_data, input_label])
    parse_result(result, "")
  end

  def detect_with_one_class_svm(data, nu_value \\ "") do
    json_data = Jason.encode!(data)
    {result, _} = System.cmd("python3", ["scripts/one_class_svm.py", json_data, ""])
    parse_result(result, data)
  end

  def detect_with_local_outlier(data, neighbours \\ "") do
    json_data = Jason.encode!(data)
    {result, _} = System.cmd("python3", ["scripts/local_outlier.py", json_data, ""])
    parse_result(result, data)
  end

  defp parse_result(result, _data) do
    result
    |> Jason.decode!()
  end
end
