defmodule BankWeb.SummaryController do
  use BankWeb.Web, :controller
  alias Bank.{UsersQueries, AccountsQueries}
  alias Plug.{Conn}

  @moduledoc """
  This is the SummaryController module.
  It contains the the actions requireds for the GET action on the summary page
  """

  @doc """
    GET action for the summary page, renders the page and pass the account the user ti the view
  """
  def index(conn, _params) do
    id = String.to_integer(Plug.Conn.get_session(conn, "user_id"))
    account = AccountsQueries.get_by_owner(id)
    user = UsersQueries.get_by_id(id)

    conn
    |> Conn.put_session("account_id", Integer.to_string(account.id))
    |> render("summary.html", account: account, user: user)
  end
end
