defmodule BuildAnomatron.Jenkins do
  @moduledoc """
  The Jenkins context.
  """

  import Ecto.Query, warn: false
  alias BuildAnomatron.Repo

  alias BuildAnomatron.Jenkins.Build

  @doc """
  Returns the list of builds.

  ## Examples

      iex> list_builds()
      [%Build{}, ...]

  """
  def list_builds do
    Repo.all(Build)
  end

  @doc """
  Gets a single build.

  Raises `Ecto.NoResultsError` if the Build does not exist.

  ## Examples

      iex> get_build!(123)
      %Build{}

      iex> get_build!(456)
      ** (Ecto.NoResultsError)

  """
  def get_build!(id), do: Repo.get!(Build, id)

  @doc """
  Creates a build.

  ## Examples

      iex> create_build(%{field: value})
      {:ok, %Build{}}

      iex> create_build(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_build(attrs \\ %{}) do
    %Build{}
    |> Build.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a build.

  ## Examples

      iex> update_build(build, %{field: new_value})
      {:ok, %Build{}}

      iex> update_build(build, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_build(%Build{} = build, attrs) do
    build
    |> Build.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a build.

  ## Examples

      iex> delete_build(build)
      {:ok, %Build{}}

      iex> delete_build(build)
      {:error, %Ecto.Changeset{}}

  """
  def delete_build(%Build{} = build) do
    Repo.delete(build)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking build changes.

  ## Examples

      iex> change_build(build)
      %Ecto.Changeset{data: %Build{}}

  """
  def change_build(%Build{} = build, attrs \\ %{}) do
    Build.changeset(build, attrs)
  end

  def pull_build_data(%Build{} = build) do
    build_url = build.job_url <> "/api/json"
    case BuildAnomatron.BaseApi.get_json build_url do
    {:error, _} -> false
    {:ok, {_, json_data} } ->
      regex = ~r/\((?<username>[^,]+),\s*(?<branch>[^\)]+)\)/
      regex_data = Regex.named_captures(regex, json_data["fullDisplayName"])
      %{
        build_id: build.id,
        job_name: build.job_name,
        job_url: json_data["url"],
        job_number: json_data["id"],
        branch: regex_data["branch"], 
        user_name: regex_data["username"],
        status: json_data["result"],
        built_on: json_data["builtOn"],
        console_url: build.job_url <> "/consoleFull",
        execution_time: Integer.to_string(json_data["duration"]),
        estimated_duration: Integer.to_string(json_data["estimatedDuration"]),
        job_timestamp: Integer.to_string(json_data["timestamp"])
      }
    end
  end

  def add_log_for_build(%Build{} = build) do
    build
    |> pull_build_data()
    |> BuildAnomatron.LogAnalysis.create_log_entry()
  end
  def add_log_for_build(false), do: false
end
