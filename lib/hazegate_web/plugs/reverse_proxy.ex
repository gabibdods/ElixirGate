defmodule HazegateWeb.Plugs.ReverseProxy do
  @behaviour Plug

  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, opts) do
    target = opts[:target] || ""
    path = conn.request_path
    query = conn.query_string
    full_url = build_url(target, path, query)

    {:ok, body, conn} = read_body(conn)

    case HTTPoison.request(conn.method, full_url, body, conn.req_headers, []) do
      {:ok, %HTTPoison.Response{status_code: code, body: resp_body, headers: resp_headers}} ->
        conn
        |> put_resp_headers(resp_headers)
        |> send_resp(code, resp_body)
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Proxy error: #{inspect(reason)}")
        send_resp(conn, 502, "Bad Gateway")
    end
  end

  defp build_url(target, path, ""), do: "#{target}#{path}"
  defp build_url(target, path, query), do: "#{target}#{path}?#{query}"

  defp put_resp_headers(conn, resp_headers) do
    Enum.reduce(resp_headers, conn, fn {k, v}, acc ->
      put_resp_header(acc, k, v)
    end)
  end
end
