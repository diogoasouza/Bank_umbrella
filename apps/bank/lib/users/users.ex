defmodule Bank.Users do
  use Ecto.Schema
  import Ecto.Changeset
  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string#Comeonin.Ecto.Password
    has_one :accounts, Bank.Accounts, foreign_key: :owner
    timestamps()
  end

  @required_fields ~w(name email password)a

  def changeset(user, params \\ %{}) do
        user
        |> cast(params, @required_fields)
        |> validate_required(@required_fields)
  end

  # def signup(user, params \\ %{}) do
  #       user
  #    |> cast(params, [:email, :password])
  #    # |> unique_constraint(:email, message: "that email is already taken")
  #    # |> validate_required(~w(email password)a)
  #    |> validate_format(:email, ~r/@/)
  #    |> validate_password()
  #  end

   def signup(email,password) do
     user = Bank.UsersQueries.get_by_email(email)
     password === user.password

   end
   # def validate_password(user) do
   #   password = get_change(user, :password)
   #   user2 = Bank.Repo.get(Users, get_change(user, :id))
   #   Comeonin.Ecto.Password.valid?(password, user2.password)
   # end
   def validate_password(changeset) do
     password = changeset.password
     user = Bank.UsersQueries.get_by_id(changeset.id)
     # user = Bank.Repo.get(Users, get_change(user, :id))
     if password == user.password do
       changeset
     else
       changeset
        |> add_error(:password_confirmation, "wrong password!")
     end
   end
end
