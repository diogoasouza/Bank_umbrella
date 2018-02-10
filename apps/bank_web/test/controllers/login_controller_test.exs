defmodule BankWeb.LoginControllerTest do
  use BankWeb.ConnCase

  test "renders the login page", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200) =~ "Please log in"
  end

  test "renders the login page with an error flash when not all fields where filled", %{conn: conn} do
    conn = conn
    |> post("/login", %{ login: %{"email" => "", "password" => "123"}})

    assert get_flash(conn, :error) == "Please fill all camps"
  end

  test "renders the login page with errors message when password is wrong ", %{conn: conn} do
    conn = conn
    |> post("/login", %{ login: %{email: "diogo.asouza@gmail.com", password: "abc"}})

    assert html_response(conn, 200) =~ "Password and email doesnt match!"
  end

  test "renders the login page with errors message when email is in the wrong format ", %{conn: conn} do
    conn = conn
    |> post("/login", %{ login: %{email: "diogo.asouz", password: "abc"}})

    assert html_response(conn, 200) =~ "has invalid format"
  end

  test "renders the login page with errors message when the user doesnt exist ", %{conn: conn} do
    conn = conn
    |> post("/login", %{ login: %{email: "diogo.asouza2@gmail.com", password: "abc"}})

    assert html_response(conn, 200) =~ "User doesnt exist!"
  end

  test "login and renders the summary page ", %{conn: conn} do
    conn = conn
    |> post("/login", %{ login: %{email: "diogo.asouza@gmail.com", password: "123"}})

    destiny = Plug.Conn.get_resp_header(conn, "location")
    assert destiny == ["/"]
  end

  test "renders the create user page", %{conn: conn} do
    conn = get conn, "/login/new"
    assert html_response(conn, 200) =~ "Create a new account!"
  end

  test "creates a new user and goes to the login page", %{conn: conn} do
    conn = conn
    |> post("/login/new", %{ users: %{name: "Teste", email: "diogo.asouza"<>Integer.to_string(Enum.random(0..99999999))<>"@gmail.com", password: "123"}})
    destiny = Plug.Conn.get_resp_header(conn, "location")
    assert destiny == ["/login"]
  end

  test "renders the create user page with an error flash when not all fields where filled", %{conn: conn} do
    conn = conn
    |> post("/login/new", %{ users: %{name: "", email: "", password: ""}})

    assert get_flash(conn, :error) == "Please fill all camps"
  end

  test "renders the create user page with an error when the email is already in use", %{conn: conn} do
    conn = conn
    |> post("/login/new", %{ users: %{name: "Diogo", email: "diogo.asouza@gmail.com", password: "123"}})

    assert html_response(conn, 200) =~ "has already been taken"
  end

end
