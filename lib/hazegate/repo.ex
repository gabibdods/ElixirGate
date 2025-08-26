defmodule Hazegate.Repo do
  use Ecto.Repo, otp_app: :hazegate, adapter: Ecto.Adapters.Postgres

  @impl true
  def init(_type, config) do
    {:ok,
      Keyword.merge(config,
        port: 5432,
        socket_options: [:inet],
        stacktrace: true,
        ssl: [
          cacertfile: "/etc/ssl/certs/ca-certificates.crt",
          verify: :verify_peer,
          server_name_indication: ''
        ],
        pool_size: 20,
        pool_count: 3
      )
    }
  end
end
