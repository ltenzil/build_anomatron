defmodule BuildAnomatron.Dashboard do
  @moduledoc """
  The Dashboard context.
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
    raise "TODO"
  end

  @doc """
  Gets a single build.

  Raises if the Build does not exist.

  ## Examples

      iex> get_build!(123)
      %Build{}

  """
  def get_build!(id), do: raise "TODO"

  @doc """
  Creates a build.

  ## Examples

      iex> create_build(%{field: value})
      {:ok, %Build{}}

      iex> create_build(%{field: bad_value})
      {:error, ...}

  """
  def create_build(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a build.

  ## Examples

      iex> update_build(build, %{field: new_value})
      {:ok, %Build{}}

      iex> update_build(build, %{field: bad_value})
      {:error, ...}

  """
  def update_build(%Build{} = build, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Build.

  ## Examples

      iex> delete_build(build)
      {:ok, %Build{}}

      iex> delete_build(build)
      {:error, ...}

  """
  def delete_build(%Build{} = build) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking build changes.

  ## Examples

      iex> change_build(build)
      %Todo{...}

  """
  def change_build(%Build{} = build, _attrs \\ %{}) do
    raise "TODO"
  end
end
