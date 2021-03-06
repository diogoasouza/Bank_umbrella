defmodule BankWeb.Router do
  use BankWeb.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :authorized do
    plug(:browser)
    plug(BankWeb.AuthorizedPlug)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", BankWeb do
    pipe_through(:authorized)
    get("/", SummaryController, :index)
    get("/transfers/", TransfersController, :list)
    get("/transfers/new", TransfersController, :new)
    post("/transfers/new", TransfersController, :add)
    get("/transfers/split", TransfersController, :create)
    post("/transfers/split", TransfersController, :save)
    get("/currency/convert", CurrencyController, :index)
    post("/currency/convert", CurrencyController, :convert)
  end

  scope "/login", BankWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", LoginController, :index)
    post("/", LoginController, :login)
    get("/delete", LoginController, :delete)
    get("/new", LoginController, :new)
    post("/new", LoginController, :add)
  end

  # Other scopes may use custom stacks.
  # scope "/api", BankWeb do
  #   pipe_through :api
  # end
end
