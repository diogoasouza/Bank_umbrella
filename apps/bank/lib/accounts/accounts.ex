defmodule Bank.Accounts do
  use Ecto.Schema
  import Ecto.Changeset
  schema "accounts" do
    field :balance, :float
    field :currency, :string
    belongs_to :user, Bank.Users, foreign_key: :owner
    has_many :outgoing_transfers, Bank.Transfers, foreign_key: :to
    has_many :incoming_transfers, Bank.Transfers, foreign_key: :from
    timestamps()
  end

  @required_fields ~w(balance currency owner)a

  def changeset(user, params \\ %{}) do
        user
        |> cast(params, @required_fields)
        |> unique_constraint(:owner, message: "that user already has an account")
        |> validate_required(@required_fields)
  end

  def new_account(user_id) do
    changeset = changeset(%Bank.Accounts{}, %{balance: 1000, currency: "Real", owner: user_id })
    Bank.AccountsQueries.create(changeset)
  end
end
