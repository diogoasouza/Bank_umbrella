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

  def signup(user, params \\ %{}) do
        user
     |> cast(params, [:email, :password])
     |> validate_required([:email, :password])
     |> validate_format(:email, ~r/@/)
     |> validate_user()
     |> validate_password()
   end

   # def validate_password(user) do
   #   password = get_change(user, :password)
   #   user2 = Bank.Repo.get(Users, get_change(user, :id))
   #   Comeonin.Ecto.Password.valid?(password, user2.password)
   # end

   defp validate_user(changeset) do
       user = Bank.UsersQueries.get_by_email(get_change(changeset, :email))
       if user do
         changeset
       else
         changeset
          |> add_error(:user, "User doesnt exist!")
       end
   end

   defp validate_password(changeset) do
       password = get_change(changeset, :password)
       user = Bank.UsersQueries.get_by_email(get_change(changeset, :email))
       if user && password == user.password do
         changeset
       else
         changeset
          |> add_error(:password, "Password and email doesnt match!")
       end
   end

end
