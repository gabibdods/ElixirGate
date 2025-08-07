defmodule Hazegate.Repo do
  use Ecto.Repo,
    otp_app: :hazegate,
    adapter: Ecto.Adapters.Postgres
end
