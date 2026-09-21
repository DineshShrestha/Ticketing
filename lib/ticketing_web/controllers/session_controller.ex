defmodule TicketingWeb.SessionController do
  use TicketingWeb, :controller

  alias Ticketing.Accounts

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        token = Accounts.generate_user_session_token(user)
        json(conn, %{token: Base.encode64(token)})

      {:error, :invalid_credentials} ->
        conn |> put_status(401) |> json(%{error: "invalid credentials"})
    end
  end
end
