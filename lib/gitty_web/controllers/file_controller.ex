defmodule GittyWeb.FileController do
  use GittyWeb, :controller
  alias Gitty.Repos
  alias Gitty.Repos.RootCommit

  def index(conn, _params) do
    repo = %RootCommit{sha: '55ad43edf54ddadd66aae44569855e5dfc0cadc1'}
    contents = Repos.show_root(repo)
    render(conn, "index.html", contents: contents)
  end
  def show(conn, %{"path" => path, "type" => type, "hash" => hash}) do
    {content, 0} = case type do
      "blob" ->
        Repos.cat_file(hash)
      "tree" ->
        { Repos.ls_folder(hash),0}
      _ ->
        {"default", 0}
    end
    IO.inspect(content)
    render(conn, "show.html", path: path, type: type, contents: content)
  end
end
