defmodule Bank.Transfers do
  use Ecto.Schema
  import Ecto.Changeset
  schema "transfers" do
    field :amount, :float
    field :currency, :string
    belongs_to :receiver, Bank.Accounts, foreign_key: :to
    belongs_to :sender, Bank.Accounts, foreign_key: :from
    field :date, :naive_datetime
    timestamps()
  end

  @required_fields ~w(amount to)a
  @optional_fields ~w(currency date from)a
  def changeset(user, params \\ %{}) do
        user
        |> cast(params, @required_fields ++ @optional_fields)
        |> validate_required(@required_fields)
  end

end
