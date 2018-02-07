defmodule BankWeb.AuthorizedPlug do
    import Plug.Conn
    import Phoenix.Controller

    def init(options) do
        options
    end

    def call(conn, name) do
        user_id = Plug.Conn.get_session(conn, "user_id")
        authorize_user(conn, user_id)
    end

    defp authorize_user(conn, nil) do
        conn
        |> redirect(to: "/login")
        |> halt
    end

    defp authorize_user(conn, _) do
        conn
    end

end
