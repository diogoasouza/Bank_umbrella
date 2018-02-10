defmodule BankWeb.TransfersControllerTest do
  use BankWeb.ConnCase

  test "renders the list all transfers page", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> assign(:account_id, "1")
    |> get("/transfers")

    assert html_response(conn, 200) =~ "All your transfers"
  end

  test "renders the create transfer page", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> assign(:account_id, "1")
    |> get("/transfers/new")

    assert html_response(conn, 200) =~ "Make a transfer"
  end

  test "renders the create transfer page with an error flash when not all fields where filled", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> assign(:account_id, "1")
    |> post("/transfers/new", %{transfers: %{to: "", amount: ""}})

    assert get_flash(conn, :error) == "Please fill all camps"
  end

  test "Create a transfers and goes to the summary page", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> assign(:account_id, "1")
    |> post("/transfers/new", %{transfers: %{to: "2", amount: "200"}})
    Bank.AccountsQueries.deposit(1,"200")
    destiny = Plug.Conn.get_resp_header(conn, "location")
    assert destiny == ["/"]
  end

  test "renders the create transfer page with an error when not enough balance", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> assign(:account_id, "1")
    |> post("/transfers/new", %{transfers: %{to: "2", amount: "9999999"}})

    assert html_response(conn, 200) =~ "Insufficient balance!"
  end

  test "renders the create transfer page with an error when the receiver is invalid", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> assign(:account_id, "1")
    |> post("/transfers/new", %{transfers: %{to: "2099898989", amount: "200"}})

    assert html_response(conn, 200) =~ "Invalid Receiver!"
  end

  test "renders the create transfer page with an error when both currencies dont match", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> assign(:account_id, "1")
    |> post("/transfers/new", %{transfers: %{to: "3", amount: "200"}})

    assert html_response(conn, 200) =~ "Currencies from all accounts have to be the same!"
  end


  test "renders the transfers split page", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> assign(:account_id, "1")
    |> get("/transfers/split")

    assert html_response(conn, 200) =~ "Make a transfer split"
  end

  test "renders the create transfer split page with an error flash when not all fields where filled", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> assign(:account_id, "1")
    |> post("/transfers/split", %{transfers: %{amount: ""}})

    assert get_flash(conn, :error) == "Please enter the receiver's account"
  end

  test "renders the create transfer split page with an error flash when there isnt enough balance", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> assign(:account_id, "1")
    |> post("/transfers/split", %{transfers: %{to: ["2"] , amount: "9999999999999999999999"}})

    assert get_flash(conn, :error) == "Insufficient balance!"
  end

  test "renders the create transfer split page with an error flash when one of the receivers is invalid", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> assign(:account_id, "1")
    |> post("/transfers/split", %{transfers: %{to: ["2", "999999"] , amount: "100"}})

    assert get_flash(conn, :error) == "Invalid Receiver!"
  end

  test "renders the create transfer split page with an error flash when the currencies dont match", %{conn: conn} do
    conn = conn
    |> assign(:user_id, "1")
    |> assign(:account_id, "1")
    |> post("/transfers/split", %{transfers: %{to: ["2", "3"] , amount: "100"}})

    assert get_flash(conn, :error) == "Currencies from all accounts have to be the same!"
  end

end
