defmodule Hazegate.Metrics do
  @moduledoc """
  Collects runtime metrics for the dashboard.
  """

  @doc """
  Returns a keyword map of stats.
  """
  def gather do
    [
      total_requests: total_requests(),
      uptime_seconds: uptime_seconds()
    ]
  end

  defp total_requests do
    # setup ETS counter !!!!
    22222
  end

  defp uptime_seconds do
    start = Application.get_env(:hazegate, :start_time)
    :erlang.system_time(:second) - start
  end
end
