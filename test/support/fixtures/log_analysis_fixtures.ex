defmodule BuildAnomatron.LogAnalysisFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BuildAnomatron.LogAnalysis` context.
  """

  @doc """
  Generate a log_entry.
  """
  def log_entry_fixture(attrs \\ %{}) do
    {:ok, log_entry} =
      attrs
      |> Enum.into(%{

      })
      |> BuildAnomatron.LogAnalysis.create_log_entry()

    log_entry
  end
end
