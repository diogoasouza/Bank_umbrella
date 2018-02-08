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

  @required_fields ~w(amount to currency date from)a
  @optional_fields ~w()a
  def changeset(user, params \\ %{}) do
        user
        |> cast(params, @required_fields)
        |> validate_required(@required_fields)
  end

  def new_transfer(struct, params \\%{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_receiver
    |> validate_currency
    |> validate_balance
  end
  defp validate_currency(changeset) do
      receiver_account = Bank.AccountsQueries.get_by_id(get_change(changeset, :to))
      if receiver_account do
        if receiver_account.currency === get_change(changeset, :currency) do
          changeset
        else
          changeset
          |> add_error(:currency, "Currencies from both accounts have to be the same!")
        end
      else
        changeset
      end

  end

  defp validate_balance(changeset) do
    sender_account = Bank.AccountsQueries.get_by_id(get_change(changeset, :from))
    if sender_account.balance >= get_change(changeset, :amount) do
        changeset
      else
        changeset
        |> add_error(:amount, "Insuficient balance!")
    end
  end

  defp validate_receiver(changeset) do
    receiver_account = Bank.AccountsQueries.get_by_id(get_change(changeset, :to))
    if (receiver_account && (get_change(changeset, :to) != get_change(changeset, :from))) do
      changeset
    else
      changeset
      |> add_error(:to, "Invalid Receiver!")
    end
  end
end
