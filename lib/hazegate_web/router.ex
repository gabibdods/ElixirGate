defmodule HazegateWeb.Router do
  use HazegateWeb, :router
  
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HazegateWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :basic_auth,
      username: System.get_env("ADMIN_USER"),
      password: System.get_env("ADMIN_PASS"),
      realm: "Hazegate Admin"
  end

  pipeline :proxy do
    plug HazegateWeb.Plugs.ReverseProxy,
      strip_prefix: true,
      init_mode: :runtime
  end

  scope "/admn", HazegateWeb do
    pipe_through :browser
    get "/dash", DashboardController, :index
    get "/home", PageController, :home
  end

  scope "/api", HazegateWeb do
    pipe_through :api
  end

  scope "/" do
    pipe_through :proxy
    match :*, "/*path", HazegateWeb.FallbackController, :noop
  end
 
  if Application.compile_env(:hazegate, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HazegateWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
  
  if Application.compile_env(:hazegate, :prod_dashboard, false) do
    import Phoenix.LiveDashboard.Router
	scope "/ops" do
	  pipe_through [:browser, :admin]
	  live_dashboard "/dashboard", metrics: HazegateWeb.Telemetry
	end
  end
end

defmodule HazegateWeb.FallbackController do
  use Phoenix.Controller
  def noop(conn, _params), do: conn
end
