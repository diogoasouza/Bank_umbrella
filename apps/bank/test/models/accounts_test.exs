defmodule AccountsTest do
  use ExUnit.Case
  alias Bank.{Accounts, Repo, UsersQueries, Users, AccountsQueries}

  test "valid changeset" do
    changeset = Accounts.changeset(%Accounts{}, %{balance: "2000", currency: "BRL", owner: 1})

    assert changeset.valid?
  end

  test "invalid changeset because of missing params" do
    changeset = Accounts.changeset(%Accounts{}, %{balance: "2000", owner: 1})
    refute changeset.valid?
  end

  test "valid new_account" do
    user =
      Users.new_user(%Users{}, %{
        name: "test",
        email:
          "email_for_new_account" <> Integer.to_string(Enum.random(0..99_999_999)) <> "@gmail.com",
        password: "123"
      })

    {:ok, changeset} = UsersQueries.create(user)
    assert {:ok, _} = Accounts.new_account(changeset.id)
    user = UsersQueries.get_by_email(Ecto.Changeset.get_change(user, :email))
    account = AccountsQueries.get_by_owner(user.id)
    Repo.delete(account)
    Repo.delete(user)
  end

  test "invalid new_account because user already has account" do
    assert {:error, changeset} = Accounts.new_account(1)
    refute changeset.valid?
  end
end
