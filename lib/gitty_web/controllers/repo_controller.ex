defmodule GittyWeb.RepoController do
  use GittyWeb, :controller
  alias Gitty.Repos
  alias Gitty.Repos.RootCommit

  def index(conn, _params) do
    sha = Repos.get_most_recent_commit()
    repo = %RootCommit{sha: sha}
    contents = Repos.show_root(repo)
    Repos.get_most_recent_commit()
    render(conn, "index.html", contents: contents, name: "gitty", branches: Repos.get_branches())
  end

  def show(conn, %{"id" => id}) do
    # sha = Repos.get_most_recent_commit(id)
    # repo = %RootCommit{sha: sha}
    # {content, 0} = {Repos.ls_folder(sha, %{"object_type" => "commit"}), 0}
    # contents = Repos.show_root(%RootCommit{sha: sha})
    # branches = Repos.get_branches()
    # {content, 0} = case type do
    #   "blob" ->
    #     Repos.cat_file(hash)
    #   "tree" ->
    #     { Repos.ls_folder(hash),0}
    #   _ ->
    #     {"default", 0}
    # end
    # IO.inspect(content)
    # render(conn, "show.html", contents: content)
    render(conn, "show.html", type: id)
  end
end
