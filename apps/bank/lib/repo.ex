defmodule Bank.Repo do
  use Ecto.Repo, otp_app: :bank

  def url do
    "ecto://user@localhost/app_#{Mix.env()}"
  end
end
