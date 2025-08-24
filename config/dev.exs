import Config

config :hazegate, HazegateWeb.Endpoint,
  url: [
    host: "localhost",
    port: 4000,
    scheme: "http"
  ],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  render_errors: [layout: true],
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:hazegate, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:hazegate, ~w(--watch)]}
  ],
  live_reload: [
    web_console_logger: true,
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/hazegate_web/(?:controllers|live|components|router)/?.*\.(ex|heex)$",
      ~r"lib/hazegate_web/plugs/(?:reverse_proxy|api_proxy).*ex$"
    ]
  ]

config :hazegate, Hazegate.Repo, show_sensitive_data_on_connection_error: true

config :swoosh,
  local: true

config :logger, :default_formatter,
  level: :debug,
  format: "$time $metadata [$level] $message\n",
  metadata: [:request_id],
  colors: [enabled: true]

config :phoenix, :stacktrace_depth, 20

config :phoenix_live_view,
  debug_heex_annotations: true,
  debug_attributes: true,
  enable_expensive_runtime_checks: true
