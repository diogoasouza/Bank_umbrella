defmodule BankWeb.SummaryViewTest do
  use BankWeb.ConnCase, async: true
  alias BankWeb.{SummaryView}

  test "should convert a float to a string with 2 decimals, rouding up" do
    float = 270.298
    formatted = SummaryView.format_money(float)
    assert formatted == "270.30"
  end

  test "should convert a float to a string with 2 decimals, rouding down" do
    float = 270.293
    formatted = SummaryView.format_money(float)
    assert formatted == "270.29"
  end

  test "should convert a the currency name to its plural, Real -> reais" do
    formatted = SummaryView.format_currency("BRL")
    assert formatted == "reais"
  end

  test "should convert a the currency name to its plural, Dollar -> dolares" do
    formatted = SummaryView.format_currency("USD")
    assert formatted == "dolares"
  end

  test "should convert a the currency name to its plural, Euro -> euros" do
    formatted = SummaryView.format_currency("EUR")
    assert formatted == "euros"
  end

  test "should get the account id of an user" do
    user_id = 1
    account_id = String.to_integer(SummaryView.get_account(user_id))
    account = Bank.AccountsQueries.get_by_owner(user_id)
    assert account_id == account.id
  end
end
