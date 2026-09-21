defmodule TicketingWeb.Plugs.RequireUser do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> encoded_token] ->
        with {:ok, token} <- Base.decode64(encoded_token),
             user when not is_nil(user) <- Ticketing.Accounts.get_user_by_session_token(token) do
          assign(conn, :current_user, user)
        else
          _ -> unauthorized(conn)
        end

      _ ->
        unauthorized(conn)
    end
  end

  def unauthorized(conn) do
    conn |> put_status(401) |> json(%{error: "unauthorized"}) |> halt()
  end
end
