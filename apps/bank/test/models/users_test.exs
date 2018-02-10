defmodule UsersTest do
  use ExUnit.Case
  doctest Bank.Users

  test "valid changeset" do
    changeset = Bank.Users.changeset(%Bank.Users{}, %{name: "Diogo", email: "diogo.asouza@gmail.com" , password: "123"})
    assert changeset.valid?
  end

  test "invalid changeset because of missing params(name)" do
    changeset = Bank.Users.changeset(%Bank.Users{}, %{email: "diogo.asouza@gmail.com" , password: "123"})
    refute changeset.valid?
  end

  test "valid signup changeset" do
    changeset = Bank.Users.signup(%Bank.Users{}, %{email: "Diogo.asouza@gmail.com" , password: "123"})
    assert changeset.valid?
  end

  test "invalid signup changeset because of missing params(email)" do
    changeset = Bank.Users.signup(%Bank.Users{}, %{ password: "123"})
    refute changeset.valid?
  end

  test "invalid signup changeset because of wrong email format" do
    changeset = Bank.Users.signup(%Bank.Users{}, %{email: "diogo.asoail.com" , password: "123"})
    refute changeset.valid?
  end

  test "invalid signup changeset because user doesnt exist" do
    changeset = Bank.Users.signup(%Bank.Users{}, %{email: "emailthatdoesntexist@gmail.com" , password: "123"})
    refute changeset.valid?
  end

  test "invalid signup changeset because of wrong password" do
    changeset = Bank.Users.signup(%Bank.Users{}, %{email: "diogo.asouza@gmail.com" , password: "12356"})
    refute changeset.valid?
  end

  test "valid new_user changeset" do
    changeset = Bank.Users.new_user(%Bank.Users{}, %{name: "Diogo", email: "diogo.asouza@gmail.com" , password: "123"})
    assert changeset.valid?
  end

  test "invalid new_user changeset because of missing params(name)" do
    changeset = Bank.Users.new_user(%Bank.Users{}, %{email: "diogo.asouza@gmail.com" , password: "12356"})
    refute changeset.valid?
  end

  test "invalid new_user changeset because of wrong email format" do
    changeset = Bank.Users.new_user(%Bank.Users{}, %{email: "diogo.asou.com" , password: "12356"})
    refute changeset.valid?
  end

  test "invalid new_user changeset because email is already taken" do
    changeset = Bank.Users.new_user(%Bank.Users{}, %{name: "Diogo", email: "diogo.asouza@gmail.com" , password: "123"})
    assert {:error, changeset} = Bank.UsersQueries.create(changeset)
    refute changeset.valid?
  end

end
