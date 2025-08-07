defmodule HazegateWeb.DashboardController do
  use HazegateWeb, :controller
  
  def index(conn, _params) do
    stats = Hazegate.Metrics.gather()
	render(conn, "index.html", stats: stats)
  end
end
