defmodule BuildAnomatronWeb.BuildHTML do
  use BuildAnomatronWeb, :html

  embed_templates "build_html/*"

  @doc """
  Renders a build form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def build_form(assigns)

end
