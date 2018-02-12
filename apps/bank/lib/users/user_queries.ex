defmodule Bank.UsersQueries do
  import Ecto.Query

  @moduledoc """
  This is the UsersQueries module.
  It contains the queries used to access the Users table
  """
  alias Bank.{Repo, Users}

  @doc """
    returns a random user from the database
  """
  def any do
    Repo.one(from(e in Users, select: count(e.id))) != 0
  end

  @doc """
    gets all the users from the database
  """
  def get_all do
    Repo.all(from(Users))
  end

  @doc """
    gets the user that has the email passed as param on the database
  """
  def get_by_email(email) do
    Repo.get_by(Users, email: email)
  end

  @doc """
    gets an user from it's id
  """
  def get_by_id(id) do
    Repo.get(Users, id)
  end

  @doc """
    receives an user changeset and inserts it on the database
  """
  def create(user) do
    Repo.insert(user)
  end
end
