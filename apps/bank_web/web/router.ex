defmodule BankWeb.Router do
  use BankWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authorized do
    plug :browser
    plug BankWeb.AuthorizedPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BankWeb do
    pipe_through :authorized
    get "/", PageController, :index
    get "/summary/", SummaryController, :index
    get "/transfers/", TransfersController, :list
    get "/transfers/new", TransfersController, :new
    post "/transfers/new", TransfersController, :add
    get "/currency/convert", CurrencyController, :index
    post "/currency/convert", CurrencyController, :convert
  end

  scope "/login", BankWeb do
    pipe_through :browser # Use the default browser stack


    get "/", LoginController, :index
    get "/delete", LoginController, :delete
    post "/", LoginController, :login
    get "/new", LoginController, :new
    post "/new", LoginController, :add
  end
  # Other scopes may use custom stacks.
  # scope "/api", BankWeb do
  #   pipe_through :api
  # end
end
