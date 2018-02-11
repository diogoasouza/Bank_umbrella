defmodule Bank.AccountsQueries do
  import Ecto.Query
  @moduledoc """
 This is the AccountsQueries module.
It contains the queries used to access the Accounts table
 """

  alias Bank.{Repo, Users, Transfers, Accounts}

  @doc """
    Returns a random account from the database
  """
  def any do
        Repo.one(from e in Accounts, select: count(e.id)) != 0
    end

    @doc """
      Gets the account from the database that belongs to the 'owner'
    """
  def get_by_owner(owner) do
    Repo.get_by(Accounts, owner: owner)
  end

  @doc """
    Gets an account by it's id
  """
  def get_by_id(id) do
    Repo.get(Accounts, id)
  end

  @doc """
    Receives an account changeset and inserts it into the database
  """
    def create(account) do
        Repo.insert(account)
    end

    @doc """
      receives an account id and an amount, and withdrawls that amount from the account that has the id that was passed
    """
    def withdrawl(id, amount) when is_float(amount) do
        account = Repo.get!(Accounts, id)
        changes = Ecto.Changeset.change account, balance: account.balance - amount
        Repo.update changes
    end

    @doc """
      receives an account id and an amount, and withdrawls that amount from the account that has the id that was passed
    """
    def withdrawl(id, amount) do
        account = Repo.get!(Accounts, id)
        changes = Ecto.Changeset.change account, balance: account.balance - String.to_integer(amount)
        Repo.update changes
    end

    @doc """
      receives an account id and an amount, and deposit that amount into the account that has the id that was passed
    """
    def deposit(id, amount) when is_float(amount) do
        account = Repo.get!(Accounts, id)
        changes = Ecto.Changeset.change account, balance: account.balance + amount
        Repo.update changes
    end

    @doc """
      receives an account id and an amount, and deposit that amount into the account that has the id that was passed
    """
    def deposit(id, amount) do
        account = Repo.get!(Accounts, id)
        changes = Ecto.Changeset.change account, balance: account.balance + String.to_integer(amount)
        Repo.update changes
    end

    @doc """
      Updates a field on the database
    """
    def update_field(changeset) do
      Repo.update changeset
    end

end
