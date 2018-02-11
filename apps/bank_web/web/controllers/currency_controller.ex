defmodule BankWeb.CurrencyController do
    use BankWeb.Web, :controller



    def index(conn, _params) do
        account_id = String.to_integer(conn.assigns[:account_id] || Plug.Conn.get_session(conn, "account_id"))
        account = Bank.AccountsQueries.get_by_owner(account_id)
        changeset = Bank.Accounts.changeset(%Bank.Accounts{}, %{})
        render conn, "convert.html", [changeset: changeset, account: account]
    end

    def convert(conn, %{"accounts" => accounts}) do
      currency = Map.get(accounts, "currency")
      account_id = String.to_integer(conn.assigns[:account_id] || Plug.Conn.get_session(conn, "account_id"))
      account = Bank.AccountsQueries.get_by_id(account_id)
      amount = account.balance
      account_currency_api = account.currency
      currency_api = currency
      if account.currency != currency do
        amount = amount * get_rate(account_currency_api, currency_api)
        Bank.AccountsQueries.update_field(Bank.Accounts.changeset(account, %{currency: currency}))
        Bank.AccountsQueries.update_field(Bank.Accounts.changeset(account, %{balance: amount}))
      end
      redirect conn, to: summary_path(conn, :index)
    end

    def get_rate(from,to) do
      call = "https://api.fixer.io/latest?base=" <> from
      resp = HTTPoison.get! call

      resp.body
      |> Poison.decode!
      |> Map.get("rates")
      |> Map.get(to)
    end

    def format_currency(currency) do
      case currency do
        "Real" -> "BRL"
        "Dollar" -> "USD"
        "Euro" -> "EUR"
      end
    end
end
