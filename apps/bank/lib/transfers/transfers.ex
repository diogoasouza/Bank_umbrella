defmodule Bank.Transfers do
  use Ecto.Schema
  import Ecto.Changeset
  schema "accounts" do
    field :amount, :float
    field :currency, :string
    belongs_to :receiver, Bank.Accounts, foreign_key: :to
    belongs_to :sender, Bank.Accounts, foreign_key: :from
    timestamps()
  end

  @required_fields ~w(amount currency to from)a

  def changeset(user, params \\ %{}) do
        user
        |> cast(params, @required_fields)
        |> validate_required(@required_fields)
  end

end
