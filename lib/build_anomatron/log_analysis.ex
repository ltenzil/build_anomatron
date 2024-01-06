defmodule BuildAnomatron.LogAnalysis do
  @moduledoc """
  The LogAnalysis context.
  """

  import Ecto.Query, warn: false
  alias BuildAnomatron.Repo

  alias BuildAnomatron.LogAnalysis.LogEntry

  @doc """
  Returns the list of log_entries.

  ## Examples

      iex> list_log_entries()
      [%LogEntry{}, ...]

  """
  def list_log_entries do
    Repo.all(LogEntry)
  end

  @doc """
  Searches through log_entry.

  """
  def search_logs(opts \\ %{}) do
    filters = [built_on: opts["built_on"], job_name: opts["job_name"], status: opts["status"], id: opts["id"]]
    search_filters = Repo.reject_empty_values(filters)
    (from log in LogEntry, where: ^search_filters) |> Repo.all
  end

  def logs_by_ids(ids) do
    (from log in LogEntry, where: log.id in ^ids) |> Repo.all
  end

  def builds_by_status(opts \\ %{}) do
    filters = [job_name: opts[:job_name], status: opts[:status]]
    search_filters = Repo.reject_empty_values(filters)
    (from log in LogEntry, where: ^search_filters, group_by: :status,  order_by: [asc: :count],
      select: %{status: log.status, count: count(log.id)})
    |> Repo.all
  end

  def load_jobs(opts \\ %{}) do
    filters = [job_name: opts[:job_name], status: opts[:status], id: opts[:id]]
    search_filters = Repo.reject_empty_values(filters)
    (from log in LogEntry, where: ^search_filters, group_by: :job_name, order_by: [asc: :count],
      select: %{job_name: log.job_name, count: count(log.id)})
    |> Repo.all
  end

  def load_jobs_with_status(opts \\ %{}) do
    filters = [job_name: opts[:job_name], status: opts[:status]]
    search_filters = Repo.reject_empty_values(filters)
    (from log in LogEntry, where: ^search_filters,
      group_by: [:job_name], 
      order_by: [asc: :count],
      select: %{
        job_name: log.job_name,
        count: count(log.id),
        failure_count: count(fragment("CASE WHEN ? = 'FAILURE' THEN 1 END", log.status)),
        success_count: count(fragment("CASE WHEN ? = 'SUCCESS' THEN 1 END", log.status)),
        error_count: count(fragment("CASE WHEN ? = 'ERROR' THEN 1 END", log.status)),
        abort_count: count(fragment("CASE WHEN ? = 'ABORTED' THEN 1 END", log.status)),
        unstable_count: count(fragment("CASE WHEN ? = 'UNSTABLE' THEN 1 END", log.status))
    })
    |> Repo.all
  end

  def sample_data_set(total_records \\ 30, statuses \\ ["FAILURE", "SUCCESS", "ERROR", "ABORTED", "UNSTABLE" ]) do
    # num_records_per_status = div(total_records, length(statuses))

    # Enum.flat_map(statuses, fn status ->
      query = from log in LogEntry,
              # where: log.status == ^status,
              order_by: fragment("RANDOM()"),
              limit: ^total_records, 
              #^num_records_per_status,
              # select: %{job_id: log.build_id,
              #           status: fragment("CASE 
              #                              WHEN status = 'FAILURE' THEN 0
              #                              WHEN status = 'SUCCESS' THEN 1
              #                              WHEN status = 'ERROR' THEN 2
              #                              WHEN status = 'ABORTED' THEN 3
              #                              WHEN status = 'UNSTABLE' THEN 4
              #                              ELSE -1
              #                            END"),
                      select:  %{execution_time: fragment("CAST(? AS INTEGER)", log.execution_time),
                        estimated_duration: fragment("CAST(? AS INTEGER)", log.estimated_duration),
                        id: log.id
                      }

      Repo.all(query)
    # end)
  end

  def all_data() do
    sample_data_set(1000000)
  end

  def random_forest_data() do
    (from log in LogEntry,
      select: %{
        execution_time: fragment("CAST(? AS INTEGER)", log.execution_time),
        estimated_duration: fragment("CAST(? AS INTEGER)", log.estimated_duration),
        status: log.status, job_name: log.job_name, id: log.id , job_number: log.job_number             
      }
    )
    |> Repo.all()
  end


  @doc """
  Gets a single log_entry.

  Raises `Ecto.NoResultsError` if the Log entry does not exist.

  ## Examples

      iex> get_log_entry!(123)
      %LogEntry{}

      iex> get_log_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_log_entry!(id), do: Repo.get!(LogEntry, id)

  @doc """
  Creates a log_entry.

  ## Examples

      iex> create_log_entry(%{field: value})
      {:ok, %LogEntry{}}

      iex> create_log_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_log_entry(false), do: false
  def create_log_entry(attrs) do
    %LogEntry{}
    |> LogEntry.changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Updates a log_entry.

  ## Examples

      iex> update_log_entry(log_entry, %{field: new_value})
      {:ok, %LogEntry{}}

      iex> update_log_entry(log_entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_log_entry(%LogEntry{} = log_entry, attrs) do
    log_entry
    |> LogEntry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a log_entry.

  ## Examples

      iex> delete_log_entry(log_entry)
      {:ok, %LogEntry{}}

      iex> delete_log_entry(log_entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_log_entry(%LogEntry{} = log_entry) do
    Repo.delete(log_entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking log_entry changes.

  ## Examples

      iex> change_log_entry(log_entry)
      %Ecto.Changeset{data: %LogEntry{}}

  """
  def change_log_entry(%LogEntry{} = log_entry, attrs \\ %{}) do
    LogEntry.changeset(log_entry, attrs)
  end
end
