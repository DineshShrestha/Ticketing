defmodule TicketingWeb.OrderController do
  use TicketingWeb, :controller

  alias Ticketing.Orders

  def create(conn, %{"ticket_type_id" => ticket_type_id, "quantity" => quantity}) do
    case Orders.purchase_tickets(conn.assigns.current_user, ticket_type_id, quantity) do
      {:ok, %{order: order}} ->
        conn
        |> put_status(201)
        |> json(%{data: %{id: order.id, status: order.status, quantity: order.quantity}})

      {:error, :inventory, :not_enough_tickets, _} ->
        conn |> put_status(422) |> json(%{error: "not enough tickets available"})
    end
  end

  def delete(conn, %{"id" => id}) do
    order = Orders.get_order!(id)

    if order.user_id == conn.assigns.current_user.id do
      case Orders.cancel_order(order) do
        {:ok, _} ->
          json(conn, %{data: %{id: order.id, status: "cancelled"}})

        {:error, :cancel, :order_not_cancellable, _} ->
          conn |> put_status(422) |> json(%{error: "order cannot be cancelled"})
      end
    else
      conn |> put_status(403) |> json(%{error: "not your order"})
    end
  end
end
