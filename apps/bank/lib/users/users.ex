defmodule Bank.Users do
  use Ecto.Schema
  import Ecto.Changeset
  schema "users" do
    field :name, :string
    field :email, :string, unique: true
    field :password, Comeonin.Ecto.Password
    timestamps
  end

  @required_fields ~w(name email password)a

  def changeset(user, params \\ %{}) do
        user
        |> cast(params, @required_fields)
        |> validate_required(@required_fields)
  end

  def signup(user, params \\ %{}) do
        user
     |> cast(params, [:name, :email, :password])
     |> unique_constraint(:email, message: "that email is already taken")
     |> validate_required(@required_fields)
     |> validate_format(:email, ~r/@/)
     |> validate_password()
   end

   def validate_password(user) do
     password = get_change(user, :password)
     user2 = Bank.Repo.get(Users, get_change(user, :id))
     Comeonin.Ecto.Password.valid?(password, user2.password)
   end
end
