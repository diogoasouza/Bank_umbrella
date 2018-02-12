defmodule BankWeb.LoginController do
  use BankWeb.Web, :controller
  alias Bank.{Users, UsersQueries, Accounts}
  alias Plug.{Conn}

  @moduledoc """
  This is the LoginController module.
  It contains the the actions requireds for the GET and POST actions on the login and new user pages
  """

  @doc """
    GET action for the login page, renders the page with an errors changeset
  """
  def index(conn, %{errors: errors}) do
    conn
    |> render("login.html", changeset: errors)
  end

  @doc """
    GET action for the login page, renders the page with an empty changeset
  """
  def index(conn, _) do
    changeset = Users.changeset(%Users{}, %{})

    conn
    |> render("login.html", changeset: changeset)
  end

  @doc """
    Post action for the login page, used when the user didnt fill all the camps
  """
  def login(conn, %{"login" => %{"email" => email, "password" => password}})
      when byte_size(email) == 0 or byte_size(password) == 0 do
    conn
    |> put_flash(:error, "Please fill all camps")
    |> redirect(to: login_path(conn, :index))
  end

  @doc """
    Post action for the login page, if the credentials are valid it redirects to the summary page
  """
  def login(conn, %{"login" => %{"email" => email, "password" => password}}) do
    changeset = Users.signup(%Users{}, %{email: email, password: password})

    if changeset.valid? do
      user = UsersQueries.get_by_email(email)

      conn
      |> Conn.put_session("user_id", Integer.to_string(user.id))
      |> redirect(to: summary_path(conn, :index))
    else
      changeset = %{changeset | action: :insert}

      conn
      |> index(%{errors: changeset})
    end
  end

  @doc """
    GET action for the new user page, it renders the page and pass an errors changeset to it
    used when the changeset on the post action wasnt valid
  """
  def new(conn, %{errors: errors}) do
    render(conn, "create.html", changeset: errors)
  end

  @doc """
    GET action for the new user page, it renders the page and pass an empty changeset to it
  """
  def new(conn, _params) do
    changeset = Users.changeset(%Users{}, %{})
    render(conn, "create.html", changeset: changeset)
  end

  @doc """
    this is the post action for the new user page for when the user didnt fill all camps, it renders the page with an error flash
  """
  def add(conn, %{"users" => %{"name" => name, "email" => email, "password" => password}})
      when byte_size(name) == 0 or byte_size(email) == 0 or byte_size(password) == 0 do
    conn
    |> put_flash(:error, "Please fill all camps")
    |> redirect(to: login_path(conn, :new))
  end

  @doc """
    this is the POST action for the new user page, adds a new user and a new account to the database and then redirects to the login page
  """
  def add(conn, %{"users" => users}) do
    changeset = Users.new_user(%Users{}, users)

    case UsersQueries.create(changeset) do
      {:ok, _} ->
        user = UsersQueries.get_by_email(users["email"])
        Accounts.new_account(user.id)
        redirect(conn, to: login_path(conn, :index))

      {:error, reasons} ->
        new(conn, %{errors: reasons})
    end
  end

  @doc """
    The GET action on the logout page, it's triggered when the 'logout' button is clicked,
    it clears the session and redirects the user to the login page
  """
  def delete(conn, _) do
    conn
    |> reset_session
    |> put_flash(:info, "You logged out!")
    |> redirect(to: login_path(conn, :index))
  end

  @doc """
    Function used to reset the Conn session
  """
  def reset_session(conn) do
    if Conn.get_session(conn, "user_id") do
      Conn.clear_session(conn)
    else
      conn
    end
  end
end
