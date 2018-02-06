defmodule BankWeb.CurrencyController do
    use BankWeb.Web, :controller



    def index(conn, params) do
        account = Bank.AccountsQueries.get_by_owner(params["id"])
        IO.inspect(account)
        changeset = Bank.Accounts.changeset(%Bank.Accounts{}, %{})
        render conn, "convert.html", [changeset: changeset, account: account]
    end

    def convert(conn, %{"accounts" => accounts, "id" => id}) do
      currency = Map.get(accounts, "currency")
      account = Bank.AccountsQueries.get_by_owner(String.to_integer(id))
      IO.inspect(currency)
      Bank.AccountsQueries.update_field(Bank.Accounts.changeset(account, %{currency: currency}), "currency", currency)
      # case currency do
      #   "Real" ->
      #   "Dollar" ->
      #   "Euro" ->
      # end
      # account = Bank.AccountsQueries.get_by_owner(id)
      # Bank.TransfersQueries.new_transfer(account.id, String.to_integer(Map.get(transfers, "to")), Map.get(transfers, "amount"), account.currency)
      redirect conn, to: summary_path(conn, :index, account.owner)
    end

    # def create(conn, %{errors: errors}) do
    #     render conn, "create.html", changeset: errors
    # end
    #
    # def create(conn, _params) do
    #     changeset = Bank.Events.changeset(%Bank.Events{}, %{})
    #     render conn, "create.html", changeset: changeset
    # end
    #
    # def add(conn, %{"events" => events}) do
    #     events = Map.update!(events, "date", fn x -> x <> ":00" end)
    #
    #     changeset = Bank.Events.changeset(%Bank.Events{}, events)
    #
    #     case Bank.EventQueries.create changeset do
    #         {:ok, %{id: id}} -> redirect conn, to: event_path(conn, :show, id)
    #         {:error, reasons} -> create conn, %{errors: reasons}
    #     end
    # end
    #
    # def reserve(conn, %{"id" => id, "reservation" => %{"quantity" => quantity}}) do
    #     {:ok, event} = Bank.EventQueries.decrease_quantity(id, quantity)
    #     BankWeb.EventChannel.send_update(event)
    #     redirect conn, to: event_path(conn, :show, id)
    # end
end
