defmodule Gitty.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @crdt_base 65536
  @default_site 0

  # We should probably guarantee that the slugs are unique, but it doesn't
  # really matter for the purpose of the demo.
  @coder Hashids.new([salt: "gitty", min_len: 6])

  schema "documents" do
    field :title, :string
    field :contents, :string
    belongs_to :user, Gitty.Accounts.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :contents, :user_id])
    |> validate_length(:contents, min: 1, max: 3000)
    #|> validate_required([:title, :contents])
  end

  @spec default :: %{
          optional(<<_::40, _::_*24>>) =>
            binary
            | maybe_improper_list(
                binary | maybe_improper_list(any, binary | []) | byte,
                binary | []
              )
        }
  def default() do
    %{ "title" => "untitled",
       "contents" => crdt_to_json(string_to_crdt("Ready"))
    }
  end

  @spec slug_from_id([non_neg_integer, ...] | non_neg_integer) :: binary
  def slug_from_id(id) do
    Hashids.encode(@coder, id)
  end

  def id_from_slug(slug) do
    Hashids.decode(@coder, slug)
  end

  def json_to_crdt(json) do
    json
    |> Poison.decode!
    |> Enum.map(fn [position_identifier, lamport, char] ->
      {Enum.map(position_identifier, fn [digit, site] -> {digit, site} end), lamport, char}
    end)
  end

  def crdt_to_json(crdt) do
    crdt_to_json_ready(crdt)
    |> Poison.encode!
  end

  def crdt_to_json_ready(crdt) do
    crdt
    |> Enum.map(fn {position_identifier, lamport, char} ->
      [Enum.map(position_identifier, fn {digit, site} -> [digit, site] end), lamport, char]
    end)
  end

  def string_to_crdt(string) do
    # TODO: support for bigger strings
    # (right now this is used only for the default string)
    if String.length(string) >= @crdt_base do
      throw "no supported yet"
    end

    string
    |> String.to_charlist
    |> Enum.with_index
    |> Enum.map(fn {char, index} ->
      identifier = { trunc(index / String.length(string) * @crdt_base) + 1, @default_site }
      { [identifier], index, to_string([char]) }
    end)
  end
end
