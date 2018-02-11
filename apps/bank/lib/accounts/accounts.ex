defmodule Bank.Accounts do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
 This is the Users module.
 It contains the accounts schema and the changeset used to create a new account
 """

  schema "accounts" do
    field :balance, :float
    field :currency, :string
    belongs_to :user, Bank.Users, foreign_key: :owner
    has_many :outgoing_transfers, Bank.Transfers, foreign_key: :to
    has_many :incoming_transfers, Bank.Transfers, foreign_key: :from
    timestamps()
  end

  @required_fields ~w(balance currency owner)a

  @doc """
    Creates a new changeset that is used to create a new account
    It validates the required fields and if the user already has an account
    A user can only have one account because this application was made for a financial institucion that isn't a bank,
    so there's only one type of account an user can have
  """
  def changeset(user, params \\ %{}) do
        user
        |> cast(params, @required_fields)
        |> unique_constraint(:owner, message: "that user already has an account")
        |> validate_required(@required_fields)
  end

  @doc """
    creates a changeset that is used to insert a new account on the database
    the values from balance and currency are hardcoded since there's no deposit function on this application
    and the currency from Brasil is BRL
  """
  def new_account(user_id) do
    changeset = changeset(%Bank.Accounts{}, %{balance: 1000, currency: "BRL", owner: user_id })
    Bank.AccountsQueries.create(changeset)
  end
end
