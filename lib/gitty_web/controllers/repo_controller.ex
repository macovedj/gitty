defmodule GittyWeb.RepoController do
  use GittyWeb, :controller
  alias Gitty.Repos
  alias Gitty.Repos.RootCommit

  def index(conn, _params) do
    sha = Repos.get_most_recent_commit()
    repo = %RootCommit{sha: sha}
    contents = Repos.show_root(repo)
    Repos.get_most_recent_commit()
    render(conn, "index.html", contents: contents, name: "gitty")
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", type: id)
  end
end
