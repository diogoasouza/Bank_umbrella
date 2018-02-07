defmodule BankWeb.Router do
  use BankWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BankWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", LoginController, :index
    post "/login", LoginController, :login
    get "/login/new", LoginController, :new
    post "/login/new", LoginController, :add
    get "/summary/", SummaryController, :index
    get "/transfers/", TransfersController, :list
    get "/transfers/new", TransfersController, :new
    post "/transfers/new", TransfersController, :add
    get "/currency/convert", CurrencyController, :index
    post "/currency/convert", CurrencyController, :convert
  end

  # Other scopes may use custom stacks.
  # scope "/api", BankWeb do
  #   pipe_through :api
  # end
end
