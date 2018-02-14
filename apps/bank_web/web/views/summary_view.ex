defmodule BankWeb.SummaryView do
  use BankWeb.Web, :view
  use BankWeb.Web, :controller

  def format_money(amount) do
    Float.to_string(amount, decimals: 2)
  end

  def format_currency(currency) do
    case String.downcase(currency) do
      "brl" -> "reais"
      "usd" -> "dolares"
      "eur" -> "euros"
    end
  end

  def get_account(id) do
    account = Bank.AccountsQueries.get_by_owner(id)
    Integer.to_string(account.id)
  end
end
