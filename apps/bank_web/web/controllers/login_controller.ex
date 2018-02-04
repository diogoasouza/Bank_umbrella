defmodule BankWeb.LoginController do
    use BankWeb.Web, :controller

    def index(conn, _) do
        render conn, "login.html"
    end

    def login(conn, %{"login" => %{"email" => email, "password" => password}}) do
        expiration = 60*60*24*7

        conn
        |> Plug.Conn.put_resp_cookie("user_name", name, max_age: expiration)
        |> redirect(to: "/")
    end
end
