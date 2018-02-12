defmodule TransfersTest do
  use ExUnit.Case
  alias Bank.{Transfers, UsersQueries, AccountsQueries}

  test "valid changeset" do
    changeset =
      Transfers.changeset(%Transfers{}, %{
        amount: "1000",
        currency: "BRL",
        to: 1,
        from: 2,
        date: "2019-05-23 09:00:00"
      })

    assert changeset.valid?
  end

  test "invalid changeset because of missing params" do
    changeset =
      Transfers.changeset(%Transfers{}, %{
        amount: "1000",
        currency: "BRL",
        to: 1,
        date: "2019-05-23 09:00:00"
      })

    refute changeset.valid?
  end

  test "valid new_transfers changeset" do
    changeset =
      Transfers.new_transfer(%Transfers{}, %{
        amount: "1000",
        currency: "BRL",
        to: 1,
        from: 2,
        date: "2019-05-23 09:00:00"
      })

    assert changeset.valid?
  end

  test "invalid new_transfers changeset because of missing params(date)" do
    changeset =
      Transfers.new_transfer(%Transfers{}, %{
        amount: "1000",
        currency: "BRL",
        to: 1,
        from: 2
      })

    refute changeset.valid?
  end

  test "invalid new_transfers changeset because receiver = sender" do
    changeset =
      Transfers.new_transfer(%Transfers{}, %{
        amount: "1000",
        currency: "BRL",
        to: 1,
        from: 1,
        date: "2019-05-23 09:00:00"
      })

    refute changeset.valid?
  end

  test "invalid new_transfers changeset because currencies dont match" do
    user = UsersQueries.get_by_email("teste@gmail.com")
    account = AccountsQueries.get_by_owner(user.id)

    changeset =
      Transfers.new_transfer(%Transfers{}, %{
        amount: "1000",
        currency: "BRL",
        to: account.id,
        from: 1,
        date: "2019-05-23 09:00:00"
      })

    refute changeset.valid?
  end

  test "invalid new_transfers changeset due to insufficient balance" do
    changeset =
      Transfers.new_transfer(%Transfers{}, %{
        amount: "100000000000",
        currency: "BRL",
        to: 2,
        from: 1,
        date: "2019-05-23 09:00:00"
      })

    refute changeset.valid?
  end
end
