defmodule BuildAnomatron.BuildStatusComponent do

  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
      <div>
        <div id="my-chart" phx-hook="HighchartsHook" 
             data-chart-options= {Jason.encode!(chart_options(@data))} >
          <!-- Chart will render here -->
        </div>
      </div>
    """
  end

  def chart_options(data) do
    %{
      chart: %{ type: "pie" },
      title: %{ text: "Pie Chart" },
      series: [%{
          name: "Builds by Status",
          colorByPoint: true,
          data: @builds
      }]
    }
  end

end
