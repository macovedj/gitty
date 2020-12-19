defmodule Gitty.Repo.Migrations.CreateAnonymousUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :anonymous, :boolean
    end
  end
end
