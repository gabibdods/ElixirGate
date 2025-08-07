defmodule HazegateWeb.Router do
  use HazegateWeb, :router

#  pipeline :browser do
#    plug :accepts, ["html"]
#    plug :fetch_session
#    plug :fetch_live_flash
#    plug :put_root_layout, html: {HazegateWeb.Layouts, :root}
#    plug :protect_from_forgery
#    plug :put_secure_browser_headers
#  end

#  pipeline :api do
#    plug :accepts, ["json"]
#  end

#  scope "/", HazegateWeb do
#    pipe_through :browser
#    get "/", PageController, :home
#  end

  pipeline :proxy do
    plug HazegateWeb.Plugs.ReverseProxy, target: Application.get_env(:hazegate, :proxy_target)
  end

  scope "/" do
    # Send all GET/POST/PUT/DELETE/OPTIONS through plug
    pipe_through :proxy
    match :*, "/*path", HazegateWeb.Plugs.ReverseProxy, []
  end

  # Other scopes may use custom stacks.
  # scope "/api", HazegateWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
#  if Application.compile_env(:hazegate, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
#    import Phoenix.LiveDashboard.Router

#    scope "/dev" do
#      pipe_through :browser

#      live_dashboard "/dashboard", metrics: HazegateWeb.Telemetry
#      forward "/mailbox", Plug.Swoosh.MailboxPreview
#    end
#  end
end
