defmodule BuildAnomatron.DashboardFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuildAnomatron.Dashboard` context.
  """

  @doc """
  Generate a build.
  """
  def build_fixture(attrs \\ %{}) do
    {:ok, build} =
      attrs
      |> Enum.into(%{

      })
      |> BuildAnomatron.Dashboard.create_build()

    build
  end
end
