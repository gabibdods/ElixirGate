defmodule HazegateWeb.Router do
  use HazegateWeb, :router
  
  import Plug.BasicAuth
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HazegateWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/dev" do
    pipe_through :browser
    get "/home", HazegateWeb.PageController, :home
    live_dashboard "/dashboard",
      metrics: HazegateWeb.Telemetry
    forward "/mailbox", Plug.Swoosh.MailboxPreview,
      csp_nonce_assign_key: %{script: :script_csp_nonce, style: :style_csp_nonce}
  end

  pipeline :admin do
    plug :basic_auth,
      realm: "HazeAdmin",
      callback: &__MODULE__.admin_basic_auth/2
  end

  def admin_basic_auth(user, pass) do
    %{username: u, password: p} = Application.fetch_env!(:hazegate, :admin_auth)
    user == u and pass == p
  end

  scope "/admn", HazegateWeb do
    pipe_through :admin
    get "/dash", DashboardController, :index
  end

  scope "/opts" do
    pipe_through [:browser, :admin]
  end

  pipeline :api do
    plug HazegateWeb.Plugs.ApiProxy,
      strip_prefix: true,
      init_mode: :runtime
  end

  scope "/api", HazegateWeb do
    pipe_through :api
    match :*, "/*path", FallbackController, :not_found
  end

  pipeline :proxy do
    plug HazegateWeb.Plugs.ReverseProxy,
      strip_prefix: true,
      init_mode: :runtime
  end

  scope "/", HazegateWeb  do
    pipe_through :proxy
    match :*, "/*path", FallbackController, :not_found
  end
end
