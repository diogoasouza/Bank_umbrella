defmodule BankWeb.AuthorizedPlug do
  import Plug.Conn
  import Phoenix.Controller

  @moduledoc """
  This is the AuthorizedPlug module.
  It's function is to check if a user is logged in, and redirect him to the log in page if he isnt
  """

  def init(options) do
    options
  end

  def call(conn, name) do
    user_id = conn.assigns[:user_id] || get_session(conn, :user_id)
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
    |> put_session(:user_id, conn.assigns[:user_id] || get_session(conn, :user_id))
  end
end
