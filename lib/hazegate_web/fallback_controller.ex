defmodule HazegateWeb.FallbackController do
  use HazegateWeb, :controller
  require Logger

  def not_found(conn, _params) do
    Logger.warning("""
    Error 404:
      Method: #{conn.method}
      Path: #{conn.request_path}
      Query: #{conn.query_string}
      Remote: #{format_ip(conn.remote_ip)}
      Headers: #{inspect(conn.req_headers, pretty: true, limit: :infinity)}
    """)

    conn
    |> put_status(:not_found)
    |> json(%{error: "Not Found"})
  end

  defp format_ip({a, b, c, d}), do: "#{a}.#{b}.#{c}.#{d}"
  defp format_ip(other), do: :inet.ntoa(other) |> to_string
end
