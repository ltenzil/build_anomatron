defmodule BuildAnomatron.JenkinsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuildAnomatron.Jenkins` context.
  """

  @doc """
  Generate a build.
  """
  def build_fixture(attrs \\ %{}) do
    {:ok, build} =
      attrs
      |> Enum.into(%{
        job_name: "some job_name",
        number: 42,
        status: "some status"
      })
      |> BuildAnomatron.Jenkins.create_build()

    build
  end
end
