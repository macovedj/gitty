defmodule GittyWeb.UserController do
  use GittyWeb, :controller

  alias Gitty.Accounts
  alias Gitty.Accounts.User
  plug :authenticate when action in [:index, :show]

  def index(conn, _params) do
        users = Accounts.list_users()
        render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = Accounts.change_registration(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> GittyWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: Routes.document_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create_anonymous() do
    unique_user = "Guest" <> to_string(:rand.uniform(99999));
    if Gitty.Repo.get_by(User, username: unique_user) == nil do
      anonymous = %User{name: unique_user, username: unique_user, anonymous: true}
      Gitty.Repo.insert!(anonymous)
    else
      # Generate random usernames until we find an unique one
      create_anonymous()
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
