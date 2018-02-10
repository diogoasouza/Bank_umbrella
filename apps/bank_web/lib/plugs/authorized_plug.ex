defmodule BankWeb.AuthorizedPlug do
    import Plug.Conn
    import Phoenix.Controller

    def init(options) do
        options
    end

    def call(conn, name) do
        user_id = conn.assigns[:user_id] || get_session(conn, :user_id)
        # user_id = assign(conn,:username, conn.assigns[:username] || Plug.Conn.get_session(conn, "user_id"))
        authorize_user(conn, user_id)
    end

    defp authorize_user(conn, nil) do
        conn
        |> put_flash(:error, "You need to be logged in to access that!")
        |> redirect(to: "/login")
        |> halt
    end

    defp authorize_user(conn, _) do
        conn
        |> put_session(:user_id, conn.assigns[:user_id] || get_session(conn, :user_id) )
    end

end
