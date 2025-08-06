defmodule ElixirGate.ReverseProxy do
    import Plug.Conn
    require Logger

    def init(opts), do: opts

    def call(conn, opts) do
        target = opts[:target]
        path = conn.request_path
        query = conn.query_string
        full_url = "#{target}#{path}?#{query}"

        headers = Enum.into(conn.req_headers, %{})

        {:ok, body, _conn} = Plug.Conn.read_body(conn)

        case HTTPoison.request(conn.method, full_url, body, conn.req_headers, []) do
            {:ok, %HTTPoison.Response{status:code, body: resp_body, headers: resp_headers}} ->
                conn
                |> put_resp_headers(resp_headers)
                |> send_resp(code, resp_body)
            {:error, reason} ->
                Logger.error("Proxy error: #{inspect(reason)}")
                send_resp(conn, 502, "Bad Gateway")
        end
    end

    def put_resp_headers(conn, headers) do
        Enum.reduce(headers, conn, fn {k, v}, acc -> Plug.Conn.put_resp_header(acc, k, v) end)
    end
end
