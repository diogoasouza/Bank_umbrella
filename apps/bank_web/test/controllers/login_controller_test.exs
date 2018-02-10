defmodule BankWeb.LoginControllerTest do
  use BankWeb.ConnCase

  test "renders the login page", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200) =~ "Please log in"
  end

  test "it renders the summary page if a user is logged in (there's an user_id at conn.assigns)", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> get("/")

    assert html_response(conn, 200) =~ "Bem vindo"
  end


end
