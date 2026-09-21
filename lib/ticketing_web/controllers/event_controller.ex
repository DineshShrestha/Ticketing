defmodule TicketingWeb.EventController do
  use TicketingWeb, :controller

  alias Ticketing.Events

  def index(conn, _params) do
    events = Events.list_events()
    render(conn, :index, events: events)
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    render(conn, :show, event: event)
  end
end
