defmodule Hazegate.Logging.DBLoggerBackend do
  @behaviour :gen_event
  alias Hazegate.Logging.Ingest

  def init(_opts), do: {:ok, %{level: :error}}

  def handle_event({level, _gl, {Logger, msg, _ts, meta}}, state) do
    if Logger.compare_levels(level, state.level) != :lt do
      Ingest.async_ingest(%{
        level: Atom.to_string(level),
        message: IO.iodata_to_binary(msg),
        meta: Map.new(meta, fn {k, v} -> {to_string(k), safe_to_string(v)} end)
      })
    end
    {:ok, state}
  end

  def handle_event(_event, state), do: {:ok, state}
  def handle_call(_req, state), do: {:ok, :ok, state}
  def handle_info(_msg, state), do: {:ok, state}
  def code_change(_old, state, _new), do: {:ok, state}
  def terminate(_reason, _state), do: :ok

  defp safe_to_string(v) do
    case v do
      pid when is_pid(pid) -> inspect(pid)
      _ -> to_string(v)
    end
    rescue _ -> inspect(v)
  end
end
