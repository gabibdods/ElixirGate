defmodule Hazegate.Logging.Ingest do
  alias Hazegate.Logging.ErrorLog
  alias Hazegate.Repo

  def async_ingest(attrs) do
    Task.Supervisor.start_child(Hazegate.TaskSup, fn ->
      %ErrorLog{}
      |> ErrorLog.changeset(attrs)
      |> Repo.insert()
    end)
    :ok
  end
end
