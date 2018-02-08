defmodule BankWeb.TransfersController do
    use BankWeb.Web, :controller


    def list(conn, _params) do
        account_id = String.to_integer(Plug.Conn.get_session(conn, "account_id"))
        transfers_receiver  = Bank.TransfersQueries.get_all_by_receiver(account_id)
        transfers_sender  = Bank.TransfersQueries.get_all_by_sender(account_id)
        render conn, "list.html", [sender: transfers_sender, receiver: transfers_receiver]
    end

    def new(conn, %{errors: errors}) do
      IO.inspect errors
      account_id = String.to_integer(Plug.Conn.get_session(conn, "account_id"))
      account = Bank.AccountsQueries.get_by_owner(account_id)
      render conn, "create.html", [changeset: errors, account: account]
    end

    def new(conn, _params) do
      account_id = String.to_integer(Plug.Conn.get_session(conn, "account_id"))
      changeset = Bank.Transfers.changeset(%Bank.Transfers{}, %{})
      account = Bank.AccountsQueries.get_by_owner(account_id)
      render conn, "create.html", [changeset: changeset, account: account]
    end

    def add(conn,  %{"transfers" => %{"to" => to, "amount" => amount}}) when byte_size(to)==0 or byte_size(amount)==0 do
      conn
      |> put_flash(:error, "Please fill all camps")
      |> redirect(to: transfers_path(conn, :new))
    end

    def add(conn,  %{"transfers" => %{"to" => to, "amount" => amount}}) do
      user_id =  String.to_integer(Plug.Conn.get_session(conn, "user_id"))
      account = Bank.AccountsQueries.get_by_owner(user_id)
      changeset = Bank.TransfersQueries.new_transfer(account.id, String.to_integer(to), amount, account.currency)
      case changeset do
          {:ok, _} -> redirect conn, to: summary_path(conn, :index)
          {:error, reasons} -> new conn, %{errors: reasons}
      end
    end


end
