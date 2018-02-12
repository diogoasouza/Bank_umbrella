defmodule BankWeb.TransfersController do
  use BankWeb.Web, :controller
  alias Bank.{TransfersQueries, Transfers, AccountsQueries}
  alias Plug.{Conn}

  @moduledoc """
  This is the TransfersController module.
  It contains the the actions requireds for the GET and POST actions on the new transfers and transfer split pages
  and for the GET action on the list transfers page
  """

  @doc """
    GET action for the list transfers page, it renders the page with two changesets:
    transfers_sender, where the user is the sender
    transfers_receiver, where the user is the receiver
  """
  def list(conn, _params) do
    account_id =
      String.to_integer(conn.assigns[:account_id] || Conn.get_session(conn, "account_id"))

    transfers_receiver = TransfersQueries.get_all_by_receiver(account_id)
    transfers_sender = TransfersQueries.get_all_by_sender(account_id)
    render(conn, "list.html", sender: transfers_sender, receiver: transfers_receiver)
  end

  @doc """
    GET action for the new transfer page, it renders the page with an errors changeset
  """
  def new(conn, %{errors: errors}) do
    account_id =
      String.to_integer(conn.assigns[:account_id] || Conn.get_session(conn, "account_id"))

    account = AccountsQueries.get_by_owner(account_id)
    render(conn, "create.html", changeset: errors, account: account)
  end

  @doc """
    GET action for the new transfer page, it renders the page with an empty changeset and the user's account changeset
  """
  def new(conn, _params) do
    account_id =
      String.to_integer(conn.assigns[:account_id] || Conn.get_session(conn, "account_id"))

    changeset = Transfers.changeset(%Transfers{}, %{})
    account = AccountsQueries.get_by_owner(account_id)
    render(conn, "create.html", changeset: changeset, account: account)
  end

  @doc """
    Post action for the new transfer page, used when the user didnt fill all the camps
  """
  def add(conn, %{"transfers" => %{"to" => to, "amount" => amount}})
      when byte_size(to) == 0 or byte_size(amount) == 0 do
    conn
    |> put_flash(:error, "Please fill all camps")
    |> redirect(to: transfers_path(conn, :new))
  end

  @doc """
    Post action for the new transfer page, it renders the summary page if successful
  """
  def add(conn, %{"transfers" => %{"to" => to, "amount" => amount}}) do
    user_id = String.to_integer(Conn.get_session(conn, "user_id"))
    account = AccountsQueries.get_by_owner(user_id)

    changeset =
      TransfersQueries.new_transfer(
        account.id,
        String.to_integer(to),
        amount,
        account.currency
      )

    case changeset do
      {:ok, _} -> redirect(conn, to: summary_path(conn, :index))
      {:error, reasons} -> new(conn, %{errors: reasons})
    end
  end

  @doc """
    GET action for the transfers split page, renders the page with an empty changeset and an account changeset
  """
  def create(conn, _params) do
    account_id =
      String.to_integer(conn.assigns[:account_id] || Conn.get_session(conn, "account_id"))

    changeset = Transfers.changeset(%Transfers{}, %{})
    account = AccountsQueries.get_by_owner(account_id)
    render(conn, "rateio.html", changeset: changeset, account: account)
  end

  @doc """
    Post action for the transfer split page, it validates the transaction and renders the summary page if successful
  """
  def save(conn, %{"transfers" => %{"to" => to, "amount" => amount}}) do
    number_of_receivers = Enum.count(to)
    amount_per_receiver = String.to_integer(amount) / number_of_receivers
    user_id = String.to_integer(Conn.get_session(conn, "user_id"))
    account = AccountsQueries.get_by_owner(user_id)

    if String.to_integer(amount) > account.balance do
      conn
      |> put_flash(:error, "Insufficient balance!")
      |> redirect(to: transfers_path(conn, :create))
    else
      if check_receivers(to) do
        if check_currency(account.currency, to) do
          for e <- to do
            changeset =
              TransfersQueries.new_transfer(
                account.id,
                String.to_integer(e),
                amount_per_receiver,
                account.currency
              )

            case changeset do
              {:ok, _} ->
                changeset

              {:error, reasons} ->
                conn
                |> put_flash(:error, get_error(reasons.errors))
                |> redirect(to: transfers_path(conn, :create))
            end
          end

          redirect(conn, to: summary_path(conn, :index))
        else
          conn
          |> put_flash(:error, "Currencies from all accounts have to be the same!")
          |> redirect(to: transfers_path(conn, :create))
        end
      else
        conn
        |> put_flash(:error, "Invalid Receiver!")
        |> redirect(to: transfers_path(conn, :create))
      end
    end
  end

  @doc """
    Function used to check if a receiver exists
  """
  defp check_receiver(receiver) do
    is_nil(AccountsQueries.get_by_id(String.to_integer(receiver)))
  end

  @doc """
    Function used to check if all the receivers are valid
  """
  defp check_receivers(receivers) do
    if Enum.empty?(receivers) do
      true
    else
      first = List.first(receivers)
      receivers = List.delete(receivers, first)

      case check_receiver(first) do
        true -> false
        false -> check_receivers(receivers)
      end
    end
  end

  @doc """
    Function used to compare two currencies
  """
  defp compare_currency(currency, receiver) do
    account = AccountsQueries.get_by_id(String.to_integer(receiver))
    currency == account.currency
  end

  @doc """
    Function used to compare the currency from the user's account to the currency of multiple receivers
  """
  defp check_currency(currency, receivers) do
    if Enum.empty?(receivers) do
      true
    else
      first = List.first(receivers)
      receivers = List.delete(receivers, first)

      case compare_currency(currency, first) do
        true -> check_currency(currency, receivers)
        false -> false
      end
    end
  end

  @doc """
    POST action for the transfer split page, used when the user didnt enter a receiver
  """
  def save(conn, %{"transfers" => %{"amount" => amount}}) do
    conn
    |> put_flash(:error, "Please enter the receiver's account")
    |> redirect(to: transfers_path(conn, :create))
  end

  @doc """
    gets the error message from a changeset
  """
  defp get_error(error) do
    error = List.first(error)
    {_, error} = error
    {error, _} = error
    error
  end
end
