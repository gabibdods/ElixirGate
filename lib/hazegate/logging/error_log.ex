defmodule Hazegate.Logging.ErrorLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "error_logs" do
    field :level, :string
    field :message, :string
    field :kind, :string
    field :exception, :string
    field :stacktrace, :string
    field :request, :map
    field :meta, :map
    timestamps(updated_at: false)
  end

  def changeset(%__MODULE__{} = log, attrs) do
    log
    |> cast(attrs, ~w[level message kind exception stacktrace request meta]a)
    |> validate_required([:level, :message])
  end
end
