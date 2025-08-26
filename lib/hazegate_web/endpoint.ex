defmodule HazegateWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :hazegate
  
  plug Plug.SSL, rewrite_on: [:x_forwarded_proto]

  @session_options [
    store: :cookie,
    key: "_hazegate_key",
    signing_salt: "S/pd75LV",
    same_site: "lax"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]],
    longpoll: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :hazegate,
    gzip: not code_reloading?,
    only: HazegateWeb.static_paths()

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus,
      otp_app: :hazegate
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId

  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride

  plug Plug.Head

  plug Plug.Session, @session_options

  plug HazegateWeb.Router
end
