defmodule BuildAnomatron.Jenkins.TimeConverter do
  
  def convert_milliseconds_to_duration(milliseconds) do
    total_seconds = div(milliseconds, 1000)
    hours = div(total_seconds, 3600)
    minutes = div(rem(total_seconds, 3600), 60)
    seconds = rem(total_seconds, 60)
    remaining_milliseconds = rem(milliseconds, 1000)

    format_duration(hours, minutes, seconds, remaining_milliseconds)
  end


  def to_mins(milliseconds) do
    String.to_integer(milliseconds)
    |> div(60000)
  end

  defp format_duration(hours, minutes, seconds, milliseconds) do
    formatted = 
      [hours, minutes, seconds]
      |> Enum.map(&pad_leading_zero/1)
      |> Enum.join(":")

    # "#{formatted}.#{pad_leading_zero(milliseconds, 3)}"
    formatted
  end

  defp pad_leading_zero(number, padding \\ 2) do
    String.pad_leading(Integer.to_string(number), padding, "0")
  end
end
