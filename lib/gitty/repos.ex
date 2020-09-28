defmodule Gitty.Repos do
  alias Gitty.Repos.RootCommit

  def cat_file(hash) do
    System.cmd("git", ["cat-file", "-p", "#{hash}"])
  end

  def get_name(plumbed_data) do
    plumbed_data
    |> String.split(" ")
    |> Enum.drop(1)
  end


  @spec format_object(any) :: %{optional(<<_::32>>) => any}
  def format_object(object) do
    %{
      "type" => Enum.at(object, 0),
      "hash" => Enum.at(object, 1) |> String.split("\t") |> Enum.at(0),
      "name" => Enum.at(object, 1) |> String.split("\t") |> Enum.at(1),
    }
  end

  def show_root(%RootCommit{} = root_commit) do
    { tree, 0 } = cat_file(root_commit.sha)

    { content, 0 } = tree
    |> String.split(" ")
    |> Enum.at(1)
    |> String.split("\n")
    |> Enum.at(0)
    |> cat_file

    content
    |> String.split("\n")
    |> Enum.map(fn x -> get_name(x) end)
    |> Enum.filter(fn x -> Kernel.length(x) != 0 end)
    |> Enum.map(fn x -> format_object(x) end)
  end

  def render_file(sha) do
    cat_file(sha)
  end

  def ls_folder(sha) do
    {content, 0} = cat_file(sha)
    content
    |> String.split("\n")
    |> Enum.map(fn x -> String.split(x, " ") end)
    |> Enum.map(fn x -> List.delete_at(x, 0) end)
    |> Enum.filter(fn x -> Kernel.length(x) != 0 end)
    |> Enum.map(fn [a, b] -> [a, String.split(b, "\t")] end)
    |> Enum.map(fn [a, b] -> %{"type" => a, "hash" => Enum.at(b, 0), "name" => Enum.at(b, 1)} end)
  end

end
