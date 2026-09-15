defmodule Ticketing.Orders do
  import Ecto.Query, warn: false
  alias Ticketing.Orders.Order
  alias Ticketing.Repo
  alias Ticketing.TicketTypes.TicketType

  def list_orders() do
    Repo.all(Order)
  end

  def get_order!(id) do
    Repo.get!(Order, id)
  end

  def create_order(attrs) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def update_order(order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  def delete_order(order) do
    Repo.delete(order)
  end

  def change_order(order, attrs) do
    order
    |> Order.changeset(attrs)
  end

  def purchase_tickets(user, ticket_type_id, quantity) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:inventory, fn _repo, _changes ->
      case decrement_inventory(ticket_type_id, quantity) do
        :ok -> {:ok, :decremented}
        :error -> {:error, :not_enough_tickets}
      end
    end)
    |> Ecto.Multi.insert(:order, fn _changes ->
      Order.changeset(%Order{}, %{
        user_id: user.id,
        ticket_type_id: ticket_type_id,
        quantity: quantity,
        status: "confirmed"
      })
    end)
    |> Repo.transaction()
  end

  defp decrement_inventory(ticket_type_id, quantity) do
    {count, _} =
      Repo.update_all(
        from(t in TicketType, where: t.id == ^ticket_type_id and t.quantity >= ^quantity),
        inc: [quantity: -quantity]
      )

    if count == 1, do: :ok, else: :error
  end

  def cancel_order(order) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:cancel, fn _repo, _changes ->
      case cancel_order_status(order) do
        :ok -> {:ok, :cancelled}
        :error -> {:error, :order_not_cancellable}
      end
    end)
    |> Ecto.Multi.run(:inventory, fn _repo, _changes ->
      increase_inventory(order.ticket_type_id, order.quantity)
      {:ok, :increased}
    end)
    |> Repo.transaction()
  end

  defp increase_inventory(ticket_type_id, quantity) do
    {count, _} =
      Repo.update_all(from(t in TicketType, where: t.id == ^ticket_type_id),
        inc: [quantity: quantity]
      )

    count
  end

  defp cancel_order_status(order) do
    {count, _} =
      Repo.update_all(from(o in Order, where: o.id == ^order.id and o.status == "confirmed"),
        set: [status: "cancelled"]
      )

    if count == 1, do: :ok, else: :error
  end
end
