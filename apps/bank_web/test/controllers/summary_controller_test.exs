defmodule BankWeb.SummaryControllerTest do
  use BankWeb.ConnCase

  test "redirect to login page if user isnt logged in (there isnt an user_id at conn.assigns)", %{
    conn: conn
  } do
    conn = get(conn, "/currency/convert")
    assert html_response(conn, 302) =~ "redirected"
  end

  test "it renders the summary page if a user is logged in (there's an user_id at conn.assigns)",
       %{conn: conn} do
    conn =
      conn
      |> assign(:user_id, "1")
      |> get("/")

    assert html_response(conn, 200) =~ "Welcome"
  end
end
