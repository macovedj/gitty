defmodule Gitty.Repo.Migrations.Documents do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :title, :string
      add :contents, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:documents, [:user_id])

  end
end
