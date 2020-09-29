defmodule GittyWeb.RepoController do
  use GittyWeb, :controller
  alias Gitty.Repos
  alias Gitty.Repos.RootCommit

  def index(conn, _params) do
    repo = %RootCommit{sha: '55ad43edf54ddadd66aae44569855e5dfc0cadc1'}
    contents = Repos.show_root(repo)
    render(conn, "index.html", contents: contents, name: "gitty")
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", type: id)
  end
end
