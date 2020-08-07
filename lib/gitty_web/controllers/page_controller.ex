defmodule GittyWeb.PageController do
  use GittyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
