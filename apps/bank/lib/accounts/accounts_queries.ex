defmodule Bank.AccountsQueries do
  import Ecto.Query

  alias Bank.{Repo, Users, Transfers, Accounts}

  def any do
        Repo.one(from e in Accounts, select: count(e.id)) != 0
    end


  def get_by_owner(owner) do
    Repo.get_by(Accounts, owner: owner)
  end

  def get_by_id(id) do
    Repo.get(Accounts, id)
  end


    def create(user) do
        Repo.insert(user)
    end

    def withdrawl(id, amount) do
        account = Repo.get!(Accounts, id)
        changes = Ecto.Changeset.change account, balance: account.balance - String.to_integer(amount)
        Repo.update changes
    end

    def deposit(id, amount) do
        account = Repo.get!(Accounts, id)
        changes = Ecto.Changeset.change account, balance: account.balance + String.to_integer(amount)
        Repo.update changes
    end

end
