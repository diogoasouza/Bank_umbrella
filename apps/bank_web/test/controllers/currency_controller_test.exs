defmodule BankWeb.CurrencyControllerTest do
  use BankWeb.ConnCase
  alias BankWeb.{CurrencyController}

  test "GET /currency/convert", %{conn: conn} do
    conn = get(conn, "/currency/convert")
    assert html_response(conn, 302) =~ "redirected"
  end

  test "it renders the currency page", %{conn: conn} do
    conn =
      conn
      |> assign(:user_id, "1")
      |> assign(:account_id, "1")
      |> get("/currency/convert")

    assert html_response(conn, 200) =~ "Currency"
  end

  test "convert Real to BRL" do
    currency = "Real"
    formatted = CurrencyController.format_currency(currency)
    assert formatted == "BRL"
  end

  test "convert Dollar to USD" do
    currency = "Dollar"
    formatted = CurrencyController.format_currency(currency)
    assert formatted == "USD"
  end

  test "convert Euro to EUR" do
    currency = "Euro"
    formatted = CurrencyController.format_currency(currency)
    assert formatted == "EUR"
  end

  test "Get the currency exchange rate for USD -> BRL" do
    formatted = CurrencyController.get_rate("USD", "BRL")
    assert is_float(formatted)
  end

  test "convert account's currency, and redirect to summary page", %{conn: conn} do
    account = Bank.AccountsQueries.get_by_id(3)

    currency_test =
      case account.currency do
        "BRL" -> "USD"
        "USD" -> "EUR"
        "EUR" -> "USD"
      end

    conn =
      conn
      |> assign(:user_id, "3")
      |> assign(:account_id, "3")
      |> post("/currency/convert", %{accounts: %{"currency" => currency_test}})

    assert html_response(conn, 302) =~ "redirected"
  end
end
