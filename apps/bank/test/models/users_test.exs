defmodule UsersTest do
  use ExUnit.Case
  alias Bank.{Users, UsersQueries}

  test "valid changeset" do
    changeset =
      Users.changeset(%Users{}, %{
        name: "Diogo",
        email: "diogo.asouza@gmail.com",
        password: "123"
      })

    assert changeset.valid?
  end

  test "invalid changeset because of missing params(name)" do
    changeset = Users.changeset(%Users{}, %{email: "diogo.asouza@gmail.com", password: "123"})

    refute changeset.valid?
  end

  test "valid signup changeset" do
    changeset = Users.signup(%Users{}, %{email: "Diogo.asouza@gmail.com", password: "123"})

    assert changeset.valid?
  end

  test "invalid signup changeset because of missing params(email)" do
    changeset = Users.signup(%Users{}, %{password: "123"})
    refute changeset.valid?
  end

  test "invalid signup changeset because of wrong email format" do
    changeset = Users.signup(%Users{}, %{email: "diogo.asoail.com", password: "123"})
    refute changeset.valid?
  end

  test "invalid signup changeset because user doesnt exist" do
    changeset =
      Users.signup(%Users{}, %{email: "emailthatdoesntexist@gmail.com", password: "123"})

    refute changeset.valid?
  end

  test "invalid signup changeset because of wrong password" do
    changeset = Users.signup(%Users{}, %{email: "diogo.asouza@gmail.com", password: "12356"})

    refute changeset.valid?
  end

  test "valid new_user changeset" do
    changeset =
      Users.new_user(%Users{}, %{
        name: "Diogo",
        email: "diogo.asouza@gmail.com",
        password: "123"
      })

    assert changeset.valid?
  end

  test "invalid new_user changeset because of missing params(name)" do
    changeset = Users.new_user(%Users{}, %{email: "diogo.asouza@gmail.com", password: "12356"})

    refute changeset.valid?
  end

  test "invalid new_user changeset because of wrong email format" do
    changeset = Users.new_user(%Users{}, %{email: "diogo.asou.com", password: "12356"})
    refute changeset.valid?
  end

  test "invalid new_user changeset because email is already taken" do
    changeset =
      Users.new_user(%Users{}, %{
        name: "Diogo",
        email: "diogo.asouza@gmail.com",
        password: "123"
      })

    assert {:error, changeset} = UsersQueries.create(changeset)
    refute changeset.valid?
  end
end
