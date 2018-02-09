defmodule BankWeb.TransfersView do
    use BankWeb.Web, :view
    use Phoenix.HTML

    def format_money(amount) do
      Float.to_string(amount, decimals: 2)
    end

    def format_currency(currency) do
      case String.downcase(currency) do
        "real" -> "reais"
        "dollar" -> "dolares"
        "euro" -> "euros"
      end
    end

    def format_time(date) do
      time = NaiveDateTime.truncate(date, :second)
      NaiveDateTime.to_time(time)
    end

    def format_date(date) do
      date = NaiveDateTime.to_date(date)
      Date.to_string(date)
    end

    
end
