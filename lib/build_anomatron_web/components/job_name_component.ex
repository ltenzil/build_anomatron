defmodule BuildAnomatron.JobNameComponent do

  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""

      <div>
      <%= for data <- @data do %>
        <div class="p-4 bg-white rounded-lg shadow my-2">
          <p><b>Chart Name:</b> <%= data.name %></p>
          <p><b>Value:</b> <%= data.value %></p>
        </div>
      <% end %>
      </div>
    """
  end

end
