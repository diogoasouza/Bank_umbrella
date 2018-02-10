defmodule TransfersTest do
  use ExUnit.Case
  
  doctest Bank.Transfers

  test "valid changeset" do
    changeset = Bank.Transfers.changeset(%Bank.Transfers{}, %{amount: "1000", currency: "Real", to: 1, from: 2, date: "2019-05-23 09:00:00"})
    assert changeset.valid?
  end

  test "invalid changeset because of missing params" do
    changeset = Bank.Transfers.changeset(%Bank.Transfers{}, %{amount: "1000", currency: "Real", to: 1, date: "2019-05-23 09:00:00"})
    refute changeset.valid?
  end

  test "valid new_transfers changeset" do
    changeset = Bank.Transfers.new_transfer(%Bank.Transfers{}, %{amount: "1000", currency: "Real", to: 1, from: 2, date: "2019-05-23 09:00:00"})
    assert changeset.valid?
  end

  test "invalid new_transfers changeset because of missing params(date)" do
    changeset = Bank.Transfers.new_transfer(%Bank.Transfers{}, %{amount: "1000", currency: "Real", to: 1, from: 2})
    refute changeset.valid?
  end

  test "invalid new_transfers changeset because receiver = sender" do
    changeset = Bank.Transfers.new_transfer(%Bank.Transfers{}, %{amount: "1000", currency: "Real", to: 1, from: 1, date: "2019-05-23 09:00:00"})
    refute changeset.valid?
  end

  test "invalid new_transfers changeset because currencies dont match" do
    user = Bank.UsersQueries.get_by_email("teste@gmail.com")
    account = Bank.AccountsQueries.get_by_owner(user.id)
    changeset = Bank.Transfers.new_transfer(%Bank.Transfers{}, %{amount: "1000", currency: "Real", to: account.id, from: 1, date: "2019-05-23 09:00:00"})
    refute changeset.valid?
  end

  test "invalid new_transfers changeset due to insufficient balance" do
    changeset = Bank.Transfers.new_transfer(%Bank.Transfers{}, %{amount: "100000000000", currency: "Real", to: 2, from: 1, date: "2019-05-23 09:00:00"})
    refute changeset.valid?
  end

end
