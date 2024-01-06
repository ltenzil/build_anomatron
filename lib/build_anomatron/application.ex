defmodule BuildAnomatron.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BuildAnomatronWeb.Telemetry,
      BuildAnomatron.Repo,
      {DNSCluster, query: Application.get_env(:build_anomatron, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BuildAnomatron.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BuildAnomatron.Finch},
      # Start a worker by calling: BuildAnomatron.Worker.start_link(arg)
      # {BuildAnomatron.Worker, arg},
      # Start to serve requests, typically the last entry
      BuildAnomatronWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BuildAnomatron.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BuildAnomatronWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
