defmodule BankWeb.TransfersController do
    use BankWeb.Web, :controller


    #
    # def index(conn, params) do
    #     account = Bank.AccountsQueries.get_by_owner(params["id"])
    #     user = Bank.UsersQueries.get_by_id(params["id"])
    #     render conn, "summary.html", [account: account, user: user]
    # end

    def list(conn, params) do
        transfers_receiver  = Bank.TransfersQueries.get_all_by_receiver(params["id"])
        transfers_sender  = Bank.TransfersQueries.get_all_by_sender(params["id"])
        render conn, "list.html", [sender_user: transfers_sender, receiver_user: transfers_receiver]
    end

    def new(conn, params) do
      changeset = Bank.Transfers.changeset(%Bank.Transfers{}, %{})
      account = Bank.AccountsQueries.get_by_owner(params["id"])
      render conn, "create.html", [changeset: changeset, account: account]
    end

    def add(conn,  %{"transfers" => transfers, "id" => id}) do
      account = Bank.AccountsQueries.get_by_owner(id)
      Bank.TransfersQueries.new_transfer(String.to_integer(id),
      String.to_integer(Map.get(transfers, "to")),
      Map.get(transfers, "amount"),
      account.currency)
      # transfers = Map.put(transfers, "date", NaiveDateTime.utc_now())
      #
      # transfers = Map.put(transfers, "currency", account.currency )
      # transfers = Map.put(transfers, "from", account.owner )
        # changeset = Bank.Events.changeset(%Bank.Events{}, events)
        #
        #
        # case Bank.EventQueries.create changeset do
        #     {:ok, %{id: id}} -> redirect conn, to: event_path(conn, :show, id)
        #     {:error, reasons} -> create conn, %{errors: reasons}
        # end
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
