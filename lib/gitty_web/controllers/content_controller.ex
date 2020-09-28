defmodule GittyWeb.ContentController do
  use GittyWeb, :controller
  alias Gitty.Repos
  alias Gitty.Repos.RootCommit

  def index(conn, params) do
    contents = Repos.render_file(params["id"])
    render(conn, "index.html", contents: contents)
  end

  def show(conn, %{"repo_id" => repo_id, "id" => id}) do
    {contents, 0} = Repos.render_file(id)
    render(conn, "show.html", contents: contents |> String.split("\n"))
  end
end
