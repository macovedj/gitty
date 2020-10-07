defmodule GittyWeb.RepoController do
  use GittyWeb, :controller
  alias Gitty.Repos
  alias Gitty.Repos.RootCommit

  def index(conn, _params) do
    sha = Repos.get_most_recent_commit()
    repo = %RootCommit{sha: sha}
    contents = Repos.show_root(repo)
    render(conn, "index.html", branch: "master", contents: contents, name: "gitty", branches: Repos.get_branches())
  end

  def show(conn, %{"id" => id}) do
    sha = Repos.get_most_recent_commit(id)
    repo = %RootCommit{sha: sha}
    contents = Repos.show_root(repo)
    render(conn, "show.html", branch: id, contents: contents, name: "gitty", branches: Repos.get_branches())
  end
end
