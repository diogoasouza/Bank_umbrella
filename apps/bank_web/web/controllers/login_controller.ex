defmodule BankWeb.LoginController do
    use BankWeb.Web, :controller

    def index(conn, _) do
      conn
      |> reset_session
      |> render "login.html"
    end

    def login(conn, %{"login" => %{"email" => email, "password" => password}}) do
        expiration = 60*60*24
        user = Bank.Users.signup(email,password)
        conn
        |> Plug.Conn.put_session("user_id", Integer.to_string(user.id))
        |> redirect(to: "/summary/")

    end

    def new(conn, _params) do
      changeset = Bank.Users.changeset(%Bank.Users{}, %{})
      render conn, "create.html", changeset: changeset
    end

    def add(conn,  %{"users" => users}) do
      changeset =  Bank.Users.changeset(%Bank.Users{}, users)
      Bank.UsersQueries.create(changeset)
      user = Bank.UsersQueries.get_by_email(users["email"])
      Bank.Accounts.new_account(user.id)
      redirect conn, to: login_path(conn, :index)
    end

    def reset_session(conn) do
      if Plug.Conn.get_session(conn, "user_id") do
        Plug.Conn.clear_session(conn)
      else
        conn
      end
    end
end
