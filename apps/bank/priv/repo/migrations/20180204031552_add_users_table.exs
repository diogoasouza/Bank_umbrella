defmodule Bank.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
        create table(:users) do
          add :name, :string, size: 50, null: false
          add :email, :string, size: 100, null: false
          add :password, :string, size: 100, null: false

          timestamps()
        end
        create unique_index(:users, [:email])
  end
end
