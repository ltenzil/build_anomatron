defmodule BuildAnomatron.Repo do
  use Ecto.Repo,
    otp_app: :build_anomatron,
    adapter: Ecto.Adapters.Postgres


  def reject_empty_values(nil), do:  []
  def reject_empty_values([]), do: []
  def reject_empty_values(filters) do
    Enum.reject(filters, fn {_key, value} ->
      (is_nil(value) || value == "")
    end)
  end
end
