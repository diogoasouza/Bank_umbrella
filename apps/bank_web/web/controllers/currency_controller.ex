defmodule BankWeb.CurrencyController do
  use BankWeb.Web, :controller
  alias Bank.{Accounts, AccountsQueries}
  alias Plug.{Conn}

  @moduledoc """
  This is the CurrencyController module.
  It contains the the actions requireds for the GET and POST actions on the convert currency page
  """

  @doc """
    this is the GET action, it renders the convert currency page, passing a changeset and the user's account
  """
  def index(conn, _params) do
    account_id =
      String.to_integer(conn.assigns[:account_id] || Conn.get_session(conn, "account_id"))

    account = AccountsQueries.get_by_owner(account_id)
    changeset = Accounts.changeset(%Bank.Accounts{}, %{})
    render(conn, "convert.html", changeset: changeset, account: account)
  end

  @doc """
    this is the POST action, it converts the user account's currency to the one selected on the template and redirects to the summary page
  """
  def convert(conn, %{"accounts" => accounts}) do
    currency = Map.get(accounts, "currency")

    account_id =
      String.to_integer(conn.assigns[:account_id] || Conn.get_session(conn, "account_id"))

    account = AccountsQueries.get_by_id(account_id)
    amount = account.balance
    account_currency_api = account.currency
    currency_api = currency

    if account.currency != currency do
      amount = amount * get_rate(account_currency_api, currency_api)
      AccountsQueries.update_field(Accounts.changeset(account, %{currency: currency}))
      AccountsQueries.update_field(Accounts.changeset(account, %{balance: amount}))
    end

    redirect(conn, to: summary_path(conn, :index))
  end

  @doc """
    Gets the currency exchange rate between two currencies (from, to)
  """
  def get_rate(from, to) do
    call = "https://api.fixer.io/latest?base=" <> from
    resp = HTTPoison.get!(call)

    resp.body
    |> Poison.decode!()
    |> Map.get("rates")
    |> Map.get(to)
  end

  @doc """
    Format the currency name to its ISO equivalent
  """
  def format_currency(currency) do
    case currency do
      "Real" -> "BRL"
      "Dollar" -> "USD"
      "Euro" -> "EUR"
    end
  end
end
