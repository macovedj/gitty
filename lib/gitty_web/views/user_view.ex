defmodule GittyWeb.UserView do
  use GittyWeb, :view

  alias Gitty.Accounts

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
