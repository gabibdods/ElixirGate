import Config

config :hazegate,
  ecto_repos: [Hazegate.Repo],
  generators: [timestamp_type: :utc_datetime]

config :hazegate, HazegateWeb.Endpoint,
  server: true,
  http: [
    ip: {0, 0, 0, 0},
    port: 4000
  ],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [formats: [html: HazegateWeb.ErrorHTML, json: HazegateWeb.ErrorJSON]],
  pubsub_server: Hazegate.PubSub,
  live_view: [signing_salt: "o883pXlL"],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :hazegate, Hazegate.Mailer,
  adapter: Swoosh.Adapters.Local

config :esbuild,
  version: "0.25.4",
  hazegate: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

config :tailwind,
  version: "4.1.7",
  hazegate: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

config :phoenix, :json_library, Jason

config :phoenix, :plug_init_mode, :runtime

config :swoosh,
  api_client: Swoosh.ApiClient.Req

import_config "#{config_env()}.exs"
#import_config "#{Mix.env()}.secrets.exs"
