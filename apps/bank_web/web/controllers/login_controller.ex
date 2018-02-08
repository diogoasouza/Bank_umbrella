defmodule BankWeb.LoginController do
    use BankWeb.Web, :controller


    def index(conn, %{errors: errors}) do
      IO.puts "JANSDJANDJANSDJKANDJANDKANSJD"
      IO.inspect errors
      conn
      |> render("login.html", changeset: errors)
    end

    def index(conn, _) do
      changeset = Bank.Users.changeset(%Bank.Users{}, %{})
      conn
      |> render "login.html", changeset: changeset
    end

    def login(conn, %{"login" => %{"email" => email, "password" => password}}) when byte_size(email) == 0 or byte_size(password) == 0 do
      conn
      |> put_flash(:error, "Please fill all camps")
      |> redirect(to: login_path(conn, :index))
    end
    def login(conn, %{"login" => %{"email" => email, "password" => password}}) do
        expiration = 60*60*24
        changeset = Bank.Users.signup(%Bank.Users{}, %{email: email, password: password})
        if changeset.valid? do
          user = Bank.UsersQueries.get_by_email(email)
          conn
          |> Plug.Conn.put_session("user_id", Integer.to_string(user.id))
          |> redirect(to: summary_path(conn, :index))
        else
          changeset = %{changeset | action: :insert}
          conn
          |> index (%{errors: changeset})
        end
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

    def delete(conn, _) do
      conn
      |> reset_session
      |> redirect(to: login_path(conn,:index))
    end

    def reset_session(conn) do
      if Plug.Conn.get_session(conn, "user_id") do
        Plug.Conn.clear_session(conn)
      else
        conn
      end
    end
end
