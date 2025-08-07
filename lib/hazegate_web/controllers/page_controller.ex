defmodule HazegateWeb.PageController do
  use HazegateWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
