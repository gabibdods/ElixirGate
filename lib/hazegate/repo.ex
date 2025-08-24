defmodule Hazegate.Repo do
  use Ecto.Repo, otp_app: :hazegate, adapter: Ecto.Adapters.Postgres

  @impl true
  def init(_type, config) do
    {:ok,
      Keyword.merge(config,
#        username: System.fetch_env!("POSTGRES_USER"),
#        password: System.fetch_env!("POSTGRES_PASSWORD"),
#        hostname: System.fetch_env!("POSTGRES_HOST"),
#        database: System.fetch_env!("POSTGRES_DB")
         socket_options: [],
         stacktrace: true,
         ssl: true,
         pool_size: 20,
         pool_count: 3
      )
    }
  end
end
