import Config

config :hazegate, HazegateWeb.Endpoint,
  server: true,
  http: [
    ip: {127, 0, 0, 1},
	port: 4000],
    check_origin: false,
    code_reloader: true,
    debug_errors: true,
    watchers: [
      esbuild: {Esbuild, :install_and_run, [:hazegate, ~w(--sourcemap=inline --watch)]},
      tailwind: {Tailwind, :install_and_run, [:hazegate, ~w(--watch)]}
    ]

    config :hazegate, HazegateWeb.Endpoint,
    live_reload: [
    web_console_logger: true,
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/hazegate_web/(?:controllers|live|components|router)/?.*\.(ex|heex)$"
    ]
  ]

config :hazegate, dev_routes: true

Do not include metadata nor timestamps in development logs
config :logger, :default_formatter, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  debug_attributes: true,
  enable_expensive_runtime_checks: true

config :swoosh, :api_client, false
