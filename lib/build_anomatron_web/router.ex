defmodule BuildAnomatronWeb.Router do
  use BuildAnomatronWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BuildAnomatronWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BuildAnomatronWeb do
    pipe_through :browser

    get "/", PageController, :home
    resources "/builds", BuildController
    get "/log_entry/index", LogEntryController, :index
    get "/anomalies", AnomalyController, :index
    get "/z_score_anomalies", AnomalyController, :z_scores

    live "/dashboard", DashboardLive.Index, :index
    live "/isolation_forest", DashboardLive.IsolationForestLive, :index
    live "/random_forest", DashboardLive.RandomForestLive, :index
    live "/svm", DashboardLive.SvmLive, :index
    live "/local_outlier", DashboardLive.LocalOutlierLive, :index

  end

  # Other scopes may use custom stacks.
  # scope "/api", BuildAnomatronWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:build_anomatron, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BuildAnomatronWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
