defmodule ElixirGate.Router do
    use Plug.Router
    require Logger

    plug Plug.Logger
    plug :match
    plug :dispatch

    forward "/folioframe", to: ElixirGate.ReverseProxy, init_opts: [target: "httpL//localhost:<redacted>"]
    forward "/node", to: ElixirGate.ReverseProxy, init_opts: [target: "http://localhost:3000"]

    match _ do
        send_resp(conn, 404, "Not Found")
    end
end
