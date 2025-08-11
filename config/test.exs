import Config

config :hazegate, HazegateWeb.Endpoint,
  http: [
    ip: {127, 0, 0, 1},
	port: 4002
  ],
  secret_key_base: "wP/KahDJ0DzFqgMSsL9eeOW5xkMteBytkXUMzbQcBk2JvNagf4AlsEnNRjdWWlb8",
  server: false

config :hazegate, Hazegate.Repo,
  username: "hazeuser",
  password: "hazepass",
  hostname: "hgdb",
  database: "hazegate_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :hazegate, Hazegate.Mailer, adapter: Swoosh.Adapters.Test

config :swoosh, :api_client, false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view, enable_expensive_runtime_checks: true
