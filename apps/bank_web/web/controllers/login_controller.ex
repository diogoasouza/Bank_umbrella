defmodule BankWeb.LoginController do
    use BankWeb.Web, :controller

    def index(conn, _) do
        render conn, "login.html"
    end

    def login(conn, %{"login" => %{"email" => email, "password" => password}}) do
        expiration = 60*60*24*7

        user = Bank.Users.signup(email,password)
        IO.puts("/summary/"<>Integer.to_string(user.id))
        conn
        |> redirect(to: "/summary/"<>Integer.to_string(user.id))
        # conn
        # |> Plug.Conn.put_resp_cookie("user_name", name, max_age: expiration)
        # |> redirect(to: "/")
    end
end
