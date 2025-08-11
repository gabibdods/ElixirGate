import Config

maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

config :hazegate, Hazegate.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  pool_count: 4,
  socket_options: maybe_ipv6

config :hazegate, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

config :hazegate, HazegateWeb.Endpoint,
  server: true,
  url: [host: System.get_env("PHX_HOST"), port: 443, scheme: "https"],
  http: [
    ip: {0, 0, 0, 0},
    port: 4000
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

if System.get_env("HAZE_ENABLE_PROD_DASHBOARD") in ["1", "true"] do
  config :hazegate, :prod_dashboard, true
end
