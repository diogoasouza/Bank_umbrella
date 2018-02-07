defmodule BankWeb.LoginController do
    use BankWeb.Web, :controller

    def index(conn, _) do
        render conn, "login.html"
    end

    def login(conn, %{"login" => %{"email" => email, "password" => password}}) do
        expiration = 60*60*24

        user = Bank.Users.signup(email,password)
        IO.puts("/summary/"<>Integer.to_string(user.id))
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
      IO.inspect(user)
      IO.inspect(user.id)
      Bank.Accounts.new_account(user.id)
      redirect conn, to: login_path(conn, :index)
    end

end
