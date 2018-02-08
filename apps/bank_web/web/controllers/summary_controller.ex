defmodule BankWeb.SummaryController do
    use BankWeb.Web, :controller



    def index(conn, _params) do
        id = String.to_integer(Plug.Conn.get_session(conn, "user_id"))
        account = Bank.AccountsQueries.get_by_owner(id)
        user = Bank.UsersQueries.get_by_id(id)
        conn
        |> Plug.Conn.put_session("account_id", Integer.to_string(account.id))
        |> render "summary.html", [account: account, user: user]
    end
end
