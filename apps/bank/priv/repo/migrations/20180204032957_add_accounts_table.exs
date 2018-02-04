defmodule Bank.Repo.Migrations.AddAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :float, null: false
      add :currency, :string, size: 100, null: false
      add :owner, references(:users), null: false

      timestamps()
    end
    create unique_index(:accounts, [:owner])
  end
end
