defmodule Rsvp.UsersQueries do
  import Ecto.Query

  alias Bank.{Repo, Users}

  def any do
        Repo.one(from e in Users, select: count(e.id)) != 0
    end

  def get_all do
    Repo.all(from Users)

  end

  def get_all_for_location(email) do
      query = from e in Users,
        where: e.email == ^email

      Repo.all(query)
  end

  def get_by_id(id) do
    Repo.get(Users, id)
  end


    def create(user) do
        Repo.insert(user)
    end


end
