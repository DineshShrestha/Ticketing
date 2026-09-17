defmodule Ticketing.OrdersTest do
  use Ticketing.DataCase

  alias Ticketing.{Venues, Events, TicketTypes, Accounts, Orders}

  setup do
    {:ok, venue} = Venues.create_venue(%{name: "Test Hall", address: "1 Main St", capacity: 50})

    {:ok, event} =
      Events.create_event(%{
        name: "Test Show",
        event_date: ~U[2026-12-01 20:00:00Z],
        venue_id: venue.id
      })

    {:ok, ticket_type} =
      TicketTypes.create_ticket_type(%{name: "GA", price: 1000, quantity: 5, event_id: event.id})

    {:ok, user} =
      Accounts.register_user(%{
        name: "Buyer",
        email: "buyer@mail.com",
        password: "supersecret123"
      })

    %{ticket_type: ticket_type, user: user}
  end

  test "purchase_tickets decrements inventory and creates a confirmed order", %{
    ticket_type: ticket_type,
    user: user
  } do
    assert {:ok, %{order: order}} = Orders.purchase_tickets(user, ticket_type.id, 2)
    assert order.status == "confirmed"
    assert order.quantity == 2

    updated_ticket_type = TicketTypes.get_ticket_type!(ticket_type.id)
    assert updated_ticket_type.quantity == 3
  end

  test "purchase_tickets fails cleanly when not enough inventory", %{
    ticket_type: ticket_type,
    user: user
  } do
    assert {:error, :inventory, :not_enough_tickets, %{}} =
             Orders.purchase_tickets(user, ticket_type.id, 6)

    updated_ticket_type = TicketTypes.get_ticket_type!(ticket_type.id)
    assert updated_ticket_type.quantity == 5
  end

  test "concurrent purchase cannot oversell", %{ticket_type: ticket_type, user: user} do
    results =
      1..10
      |> Task.async_stream(fn _ -> Orders.purchase_tickets(user, ticket_type.id, 1) end)
      |> Enum.map(fn {:ok, result} -> result end)

    count =
      Enum.count(results, fn
        {:ok, _} -> true
        _ -> false
      end)

    updated_ticket_type = TicketTypes.get_ticket_type!(ticket_type.id)

    assert count == 5
    assert updated_ticket_type.quantity == 0
  end
end
