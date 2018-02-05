defmodule BankWeb.SummaryView do
    use BankWeb.Web, :view

    def format_money(amount) do
      Float.to_string(amount, decimals: 2)
    end

    def format_time(date) do
        Ecto.DateTime.to_time(date)
        |> Ecto.Time.to_string
    end

end
