defmodule HazegateWeb.Plugs.ReverseProxy do
  @behaviour Plug
  import Plug.Conn

  @type upstream_spec :: {prefix :: binary(), target :: binary() | [binary()]}

  @impl true
  def init(opts) do
    upstreams = [
      {"/ff", "http://ffnx:80/ff"}
    ]
      |> Enum.map(fn {prefix, targets} ->
        %{prefix: ensure_leading_slash(prefix), targets: List.wrap(targets)}
      end)
      |> Enum.sort_by(&String.length(&1.prefix), :desc)

    %{mode: :multi, upstreams: upstreams, strip_prefix: Keyword.get(opts, :strip_prefix, true)}
  end

  @impl true
  def call(conn, %{mode: :none}), do: send_resp(conn, 502, "No upstreams configured") |> halt()

  def call(conn, %{mode: :single, base: base, strip_prefix: strip?}) do
    forward(conn, base, "", strip?)
  end

  def call(conn, %{mode: :multi, upstreams: upstreams, strip_prefix: strip?}) do
    path = conn.request_path

    case Enum.find(upstreams, fn u -> String.starts_with?(path, u.prefix) end) do
      nil ->
        send_resp(conn, 404, "No route for #{path}") |> halt()

      %{prefix: prefix, targets: targets} ->
        target = pick_target(targets)
        forward(conn, target, prefix, strip?)
    end
  end

  defp ensure_leading_slash(<<"/", _::binary>> = p), do: p
  defp ensure_leading_slash(p), do: "/" <> p

  defp pick_target(targets) do
    idx = :erlang.unique_integer([:positive, :monotonic])
    Enum.at(targets, rem(idx, length(targets)))
  end

  defp forward(conn, base, prefix, strip?) do
    {:ok, body, conn} = read_body(conn)

    forwarded_path =
      if strip? and prefix != "" do
        case String.replace_prefix(conn.request_path, prefix, "") do
          "" -> "/"
          s -> s
        end
      else
        conn.request_path
      end

    qs = if conn.query_string == "", do: "", else: "?" <> conn.query_string
    url = base <> forwarded_path <> qs

    clean_req_headers =
      conn.req_headers
      |> drop_hop_by_hop()
      |> Enum.reject(fn {k, _} -> String.downcase(k) in [ "content-lenght", "transfer-encoding", "expect"] end)
      |> put_forwarded_headers(conn, if(strip?, do: prefix, else: ""))

    method =
      conn.method
      |> String.downcase()
      |> String.to_existing_atom()

    finch_req = Finch.build(method, url, clean_req_headers, body)

    timeout_ms =
      if method ==:post and String.starts_with?(conn.request_path, "/ff/gate") do
        90_000
      else
        30_000
      end

      opts = [receive_timeout: timeout_ms, request_timeout: timeout_ms, pool_timeout: 10_000]

    case Finch.request(finch_req, HazegateFinch, opts) do
      {:ok, %Finch.Response{status: status, headers: resp_headers, body: resp_body}} ->
        conn
        |> put_resp_headers_safe(resp_headers)
        |> send_resp(status, resp_body)
        |> halt()

      {:error, reason} ->
        send_resp(conn, 504, "Upstream error: #{inspect(reason)}") |> halt()
    end
  end

  defp http_method_atom("GET"), do: :get
  defp http_method_atom("POST"), do: :post
  defp http_method_atom("PUT"), do: :put
  defp http_method_atom("PATCH"), do: :patch
  defp http_method_atom("DELETE"), do: :delete
  defp http_method_atom("HEAD"), do: :head
  defp http_method_atom("OPTIONS"), do: :options
  defp http_method_atom(other), do: other |> String.downcase() |> String.to_atom()

  defp drop_hop_by_hop(headers) do
    reject = ~w(connection keep-alive proxy-connection transfer-encoding upgrade)a
    Enum.reject(headers, fn {k, _} -> String.downcase(k) in reject end)
  end

  defp put_forwarded_headers(headers, conn, prefix) do
    xf_host = List.first(get_req_header(conn, "host")) || ""
    xf_proto = to_string(conn.scheme)

    xf_for =
      case conn.remote_ip do
        {_, _, _, _} = ip4 -> :inet.ntoa(ip4) |> to_string()
        ip6 when is_tuple(ip6) -> :inet.ntoa(ip6) |> to_string()
        _ -> ""
      end

    headers
    |> List.keystore("x-forwarded-host", 0, {"x-forwarded-host", xf_host})
    |> List.keystore("x-forwarded-proto", 0, {"x-forwarded-proto", xf_proto})
    |> List.keystore("x-forwarded-for", 0, {"x-forwarded-for", xf_for})
    |> List.keystore("x-forwarded-prefix", 0, {"x-forwarded-prefix", prefix})
  end

  defp put_resp_headers_safe(conn, resp_headers) do
    drop = ~w(connection keep-alive proxy-connection transfer-encoding)a

    Enum.reduce(resp_headers, conn, fn {k, v}, acc ->
      if String.downcase(k) in drop, do: acc, else: put_resp_header(acc, k, v)
    end)
  end
end
