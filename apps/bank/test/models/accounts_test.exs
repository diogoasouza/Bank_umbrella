defmodule AccountsTest do
  use ExUnit.Case

  doctest Bank.Accounts

  test "valid changeset" do
    changeset = Bank.Accounts.changeset(%Bank.Accounts{}, %{balance: "2000", currency: "BRL", owner: 1})
    assert changeset.valid?
  end

  test "invalid changeset because of missing params" do
    changeset = Bank.Accounts.changeset(%Bank.Accounts{}, %{balance: "2000", owner: 1})
    refute changeset.valid?
  end

  test "valid new_account" do
    user = Bank.Users.new_user(%Bank.Users{}, %{name: "test", email: "email_for_new_account@gmail.com" , password: "123"})
    {:ok, changeset} = Bank.UsersQueries.create(user)
    assert {:ok, _ } = Bank.Accounts.new_account(changeset.id)
    user = Bank.UsersQueries.get_by_email(Ecto.Changeset.get_change(user,:email))
    account = Bank.AccountsQueries.get_by_owner(user.id)
    Bank.Repo.delete(account)
    Bank.Repo.delete(user)
  end

  test "invalid new_account because user already has account" do
    assert {:error,changeset} = Bank.Accounts.new_account(1)
    refute changeset.valid?
  end
end
