defmodule LogAnalysis.ModelTrainer do
  def train_isolation_forest(data) do
    # Convert your data to a suitable format for Python (e.g., JSON)
    json_data = Jason.encode!(data)
    
    # Call the Python script for training
    System.cmd("python3", ["scripts/isolation_forest_train.py", json_data])
    
    # Handle the response, check for errors, etc.
  end

  def train_random_forest(data) do
    # Prepare data and labels
    # json_data = Jason.encode!(data, labels: labels})
    json_data = Jason.encode!(data)
    labels = Enum.map(data, fn(job) -> 
      case job[:execution_time] <= job[:estimated_duration] do
        true -> 1
        false -> -1
      end
    end)
    json_labels = Jason.encode!(labels)
    # Call the Python script for training
    System.cmd("python3", ["scripts/random_forest_train.py", json_data, json_labels])
    
    # Handle the response
  end

  def train_random(data) do
    json_data = Jason.encode!(data)
    System.cmd("python3", ["scripts/random_train.py", json_data])
  end
end
