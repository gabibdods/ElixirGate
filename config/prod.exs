import Config

config :hazegate, HazegateWeb.Endpoint,
 url: [
   host: "gabrieldigitprint.work",
   port: 443,
   scheme: "https"
 ],
 check_origin: true,
 code_reloader: false,
 debug_errors: false,
 render_errors: [layout: false]

config :hazegate, Hazegate.Repo, show_sensitive_data_on_connection_error: false

config :swoosh,
  local: false

config :logger,
  level: :debug
