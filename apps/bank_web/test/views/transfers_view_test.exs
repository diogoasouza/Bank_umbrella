defmodule BankWeb.TransfersViewTest do
  use BankWeb.ConnCase, async: true
  alias BankWeb.{TransfersView}

  test "should convert a float to a string with 2 decimals, rouding up" do
    float = 270.298
    formatted = TransfersView.format_money(float)
    assert formatted == "270.30"
  end

  test "should convert a float to a string with 2 decimals, rouding down" do
    float = 270.293
    formatted = TransfersView.format_money(float)
    assert formatted == "270.29"
  end

  test "should convert a the currency name to its plural, Real -> reais" do
    formatted = TransfersView.format_currency("BRL")
    assert formatted == "reais"
  end

  test "should convert a the currency name to its plural, Dollar -> dolares" do
    formatted = TransfersView.format_currency("USD")
    assert formatted == "dolares"
  end

  test "should convert a the currency name to its plural, Euro -> euros" do
    formatted = TransfersView.format_currency("EUR")
    assert formatted == "euros"
  end

  test "should format a NaiveDateTime to Date" do
    naive_date_time = ~N[2019-05-23 09:00:00.000000]
    formatted = TransfersView.format_date(naive_date_time)
    assert formatted == "2019-05-23"
  end

  test "should format a NaiveDateTime to time" do
    naive_date_time = ~N[2019-05-23 09:00:00.000000]
    formatted = TransfersView.format_time(naive_date_time)
    assert formatted == ~T[09:00:00]
  end
end
