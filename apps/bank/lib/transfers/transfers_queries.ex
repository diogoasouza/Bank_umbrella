defmodule Bank.TransfersQueries do
  import Ecto.Query

  alias Bank.{Repo, Users, Accounts, Transfers}

  def any do
        Repo.one(from e in Transfers, select: count(e.id)) != 0
    end

  def get_all do
    Repo.all(from Transfers)
  end

  def get_all_by_sender(id) do
      query = from e in Transfers,
        where: e.from == ^id

      Repo.all(query)
  end

  def get_all_by_receiver(id) do
    query = from e in Transfers,
      where: e.to == ^id

    Repo.all(query)
  end

  def get_by_id(id) do
    Repo.get(Transfers, id)
  end

 def new_transfer(sender,receiver,amount, currency) do
     changeset = Bank.Transfers.new_transfer(%Bank.Transfers{}, %{amount: amount, currency: currency, to: receiver, from: sender, date: NaiveDateTime.utc_now()})
     IO.inspect(changeset)
     if changeset.valid? do
       Bank.AccountsQueries.withdrawl(sender, amount)
       Bank.AccountsQueries.deposit(receiver, amount)
     end
     create(changeset)
 end
    def create(transfer) do
        Repo.insert(transfer)
    end

end
