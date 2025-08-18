defmodule Hazegate.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Application.put_env(:hazegate, :start_time, :erlang.system_time(:seconds))
    children = [
      HazegateWeb.Telemetry,
      Hazegate.Repo,
      {DNSCluster, query: Application.get_env(:hazegate, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Hazegate.PubSub},
      {Finch, name: HazegateFinch},
      HazegateWeb.Endpoint
      #Hazegate.Worker.start_link(arg),
      #{Hazegate.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: Hazegate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    HazegateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
