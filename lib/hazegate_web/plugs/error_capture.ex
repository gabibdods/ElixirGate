defmodule HazegateWeb.Plugs.ErrorCapture do
  @behaviour Plug
  use Plug.ErrorHandler
#  import Plug.Conn

  @impl true
  def init(opts), do: opts
  def call(conn, _opts), do: conn

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    Hazegate.Logging.Ingest.async_ingest(%{
      level: "error",
      message: Exception.message(reason),
      kind: to_string(kind),
      exception: exception_mod(reason),
      stacktrace: Exception.format_stacktrace(stack),
      request: summarize_conn(conn)
    })
  end

  defp exception_mod(%mod{}), do: Atom.to_string(mod)
  defp exception_mod(other), do: other |> inspect()

  defp summarize_conn(conn) do
    %{
      method: conn.method,
      path: conn.request_path,
      query: conn.query_string,
      remote_ip: :inet.ntoa(conn.remote_ip) |> to_string(),
      headers: sanitize_headers(conn.req_headers),
      params: conn.params
    }
  end

  defp sanitize_headers(headers) do
    headers
    |> Map.new()
  end
end
