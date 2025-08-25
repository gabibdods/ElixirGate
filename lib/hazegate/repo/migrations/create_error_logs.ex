defmodule Hazegate.Repo.Migrations.CreateErrorLogs do
  use Ecto.Migration

  def change do
    create table(:error_logs) do
      add :level, :string, null: false
      add :message, :text, null: false
      add :kind, :string
      add :exception, :string
      add :stacktrace, :text
      add :request, :map
      add :meta, :map
      timestamps(updated_at: false)
    end

    create index(:error_logs, [:inserted_at])
    create index(:error_logs, [:level])
  end
end
