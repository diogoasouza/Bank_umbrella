defmodule Bank.Users do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bank.{UsersQueries, Accounts}

  @moduledoc """
  This is the Users module.
  It contains the users schema and the changesets used to create and signup an user
  """

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string)
    has_one(:accounts, Accounts, foreign_key: :owner)
    timestamps()
  end

  @required_fields ~w(name email password)a

  @doc """
    Basic changeset function, used to pass an Ecto.Changeset to a form
  """
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

  @doc """
    returns a changeset used to signup an user.
    it validates the required fields, the email format, checks if the users exists and if the password is right
  """
  def signup(user, params \\ %{}) do
    user
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_user()
    |> validate_password()
  end

  @doc """
    returns the changeset used to create a new user
    It validates the required fields, the email format, checks the unique_constraint on the email and encodes the password
  """
  def new_user(user, params \\ %{}) do
    user
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> encode_password
  end

  @doc """
    receives a changeset as parameter and encodes the :password change
  """
  defp encode_password(changeset) do
    if get_change(changeset, :password) do
      password = get_change(changeset, :password)
      put_change(changeset, :password, Base.hex_encode32(password))
    else
      changeset
    end
  end

  @doc """
    checks if the users filled the email field and if so, checks if there's an users
    with that email on the database
  """
  defp validate_user(changeset) do
    if get_change(changeset, :email) do
      email = String.downcase(get_change(changeset, :email))
      user = UsersQueries.get_by_email(email)

      if user do
        changeset
      else
        changeset
        |> add_error(:user, "User doesnt exist!")
      end
    else
      changeset
      |> add_error(:user, "Please fill all camps!")
    end
  end

  @doc """
    compare the password provided by the user on the signup page with the Password
    associated with the email provided on the database
  """
  defp validate_password(changeset) do
    if get_change(changeset, :password) && get_change(changeset, :email) do
      password = get_change(changeset, :password)
      password = Base.hex_encode32(password)
      email = String.downcase(get_change(changeset, :email))
      user = UsersQueries.get_by_email(email)

      if user && password == user.password do
        changeset
      else
        changeset
        |> add_error(:password, "Password and email doesnt match!")
      end
    else
      changeset
      |> add_error(:password, "Please fill all camps!")
    end
  end
end
