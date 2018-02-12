defmodule Bank.Transfers do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bank.{Accounts, AccountsQueries}

  @moduledoc """
  This is the transfers module.
  It contains the transfers schema and the changeset changeset used to create a new transfers
  """

  schema "transfers" do
    field(:amount, :float)
    field(:currency, :string)
    belongs_to(:receiver, Accounts, foreign_key: :to)
    belongs_to(:sender, Accounts, foreign_key: :from)
    field(:date, :naive_datetime)
    timestamps()
  end

  @required_fields ~w(amount to currency date from)a
  @doc """
    Basic changeset function, used to pass an Ecto.Changeset to a form
  """
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

  @doc """
    Returns a changeset that is used to create a new Transfer
    It validades the receiver, currency, balance and if all fields were filled
  """
  def new_transfer(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_receiver
    |> validate_currency
    |> validate_balance
  end

  @doc """
    Compares the currencies from the sender's account and the receiver's account
  """
  defp validate_currency(changeset) do
    receiver_account = AccountsQueries.get_by_id(get_change(changeset, :to))

    if receiver_account do
      if receiver_account.currency === get_change(changeset, :currency) do
        changeset
      else
        changeset
        |> add_error(:currency, "Currencies from all accounts have to be the same!")
      end
    else
      changeset
    end
  end

  @doc """
    Check if the sender's account has enough balance to make the transfer
  """
  defp validate_balance(changeset) do
    sender_account = AccountsQueries.get_by_id(get_change(changeset, :from))

    if sender_account.balance >= get_change(changeset, :amount) do
      changeset
    else
      changeset
      |> add_error(:amount, "Insufficient balance!")
    end
  end

  @doc """
    Check if the receiver's account exists and if it's not the same as the sender's account
  """
  defp validate_receiver(changeset) do
    receiver_account = AccountsQueries.get_by_id(get_change(changeset, :to))

    if receiver_account && get_change(changeset, :to) != get_change(changeset, :from) do
      changeset
    else
      changeset
      |> add_error(:to, "Invalid Receiver!")
    end
  end
end
