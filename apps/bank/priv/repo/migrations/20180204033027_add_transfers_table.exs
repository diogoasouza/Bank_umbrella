defmodule Bank.Repo.Migrations.AddTransfersTable do
  use Ecto.Migration

  def change do
    create table(:transfers) do
      add :amount, :float, null: false
      add :currency, :string, size: 40, null: false
      add :from, references(:accounts), null: false
      add :to, references(:accounts), null: false

      timestamps()
    end
  end
end
