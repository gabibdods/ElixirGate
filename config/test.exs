import Config

config :hazegate, Hazegate.Repo,
  database: "hazegate_test" <> "#{System.fetch_env!("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online()

config :hazegate, Hazegate.Mailer,
  adapter: Swoosh.Adapters.Test

config :swoosh, :api_client, false

config :logger,
  level: :warning

config :phoenix_live_view,
  enable_expensive_runtime_checks: true
