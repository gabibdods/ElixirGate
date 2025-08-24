import Config

config :hazegate, HazegateWeb.Endpoint,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

config :hazegate, Hazegate.Repo,
  username: System.fetch_env!("POSTGRES_USER"),
  password: System.fetch_env!("POSTGRES_PASSWORD"),
  hostname: System.fetch_env!("POSTGRES_HOST"),
  database: System.fetch_env!("POSTGRES_DB")

ups_proxy =
  System.fetch_env!("UPSTREAMS_PROXY")
  |> String.split(",", trim: true)
  |> Enum.chunk_every(2)
  |> Enum.map(fn
    [f, s] -> {f, s}
    other -> raise "UPSTREAMS_PROXY incorrect: #{inspect(other)}"
    end
  )
config :hazegate, :upstreams_proxy, ups_proxy

ups_api =
  System.fetch_env!("UPSTREAMS_API")
  |> String.split(",", trim: true)
  |> Enum.chunk_every(2)
  |> Enum.map(fn
    [f, s] -> {f, s}
    other -> raise "UPSTREAMS_API incorrect: #{inspect(other)}"
    end
  )
config :hazegate, :upstreams_api, ups_api

config :hazegate, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

config :hazegate, :admin_auth,
  username: System.fetch_env!("ADMIN_USER"),
  password: System.fetch_env!("ADMIN_PASS")

config :logger,
  backends: [
    :console,
    Hazegate.Logging.DBLoggerBackend
  ]

:logger.add_handler(
  :hazegate_db_handler,
  :logger_std_h,
  %{level: :error}
)
