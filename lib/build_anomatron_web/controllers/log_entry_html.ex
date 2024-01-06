defmodule BuildAnomatronWeb.LogEntryHTML do
  use BuildAnomatronWeb, :html

  embed_templates "log_entry_html/*"

  def to_duration(nil), do: 'N/A'
  def to_duration(milliseconds) do
    String.to_integer(milliseconds)
    |> BuildAnomatron.Jenkins.TimeConverter.convert_milliseconds_to_duration()
  end

  def to_datetime(""), do: 'N/A'
  def to_datetime(nil), do: 'N/A'
  def to_datetime(milliseconds) do
    case DateTime.from_unix(String.to_integer(milliseconds), :milliseconds) do
      {:ok, datetime} -> datetime
      _ -> 'N/A'
    end
  end


end
