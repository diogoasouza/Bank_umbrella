defmodule Bank.TransfersQueries do
  import Ecto.Query

  alias Bank.{Repo, Transfers, AccountsQueries}

  @moduledoc """
  This is the TransfersQueries module.
  It contains the queries used to access the Transfers table
  """

  @doc """
    Returns a random transfers from the database
  """
  def any do
    Repo.one(from(e in Transfers, select: count(e.id))) != 0
  end

  @doc """
    returns all transfers from the database
  """
  def get_all do
    Repo.all(from(Transfers))
  end

  @doc """
    returns all transfers from the database where 'id' is the sender
  """
  def get_all_by_sender(id) do
    query = from(e in Transfers, where: e.from == ^id)

    Repo.all(query)
  end

  @doc """
    returns all transfers from the database where 'id' is the receiver
  """
  def get_all_by_receiver(id) do
    query = from(e in Transfers, where: e.to == ^id)

    Repo.all(query)
  end

  @doc """
    get a transfers by it's id
  """
  def get_by_id(id) do
    Repo.get(Transfers, id)
  end

  @doc """
    create a new transfers
    It firsts create a new_transfer changeset, and if it's valid it makes the transfer
  """
  def new_transfer(sender, receiver, amount, currency) do
    changeset =
      Transfers.new_transfer(%Transfers{}, %{
        amount: amount,
        currency: currency,
        to: receiver,
        from: sender,
        date: NaiveDateTime.utc_now()
      })

    if changeset.valid? do
      AccountsQueries.withdrawl(sender, amount)
      AccountsQueries.deposit(receiver, amount)
    end

    create(changeset)
  end

  @doc """
    insert a transfer in the database
  """
  def create(transfer) do
    Repo.insert(transfer)
  end
end
