defmodule Bank.Repo.Migrations.AddTransferTime do
  use Ecto.Migration

  def change do
    alter table(:transfers) do
      add :date, :utc_datetime
    end
  end
end
