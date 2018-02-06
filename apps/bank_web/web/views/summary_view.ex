defmodule BankWeb.SummaryView do
    use BankWeb.Web, :view

    def format_money(amount) do
      Float.to_string(amount, decimals: 2)
    end

    def format_time(date) do
        Ecto.DateTime.to_time(date)
        |> Ecto.Time.to_string
    end

    def format_currency(currency) do
      case String.downcase(currency) do
        "real" -> "reais"
        "dollar" -> "dolares"
        "euro" -> "euros"
      end
    end

    def get_account(id) do
      account = Bank.AccountsQueries.get_by_owner(id)
      Integer.to_string(account.id)
    end
end
