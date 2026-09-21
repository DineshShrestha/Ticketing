defmodule TicketingWeb.EventJSON do
  def index(%{events: events}) do
    %{data: for(event <- events, do: data(event))}
  end

  def show(%{event: event}) do
    %{data: data(event)}
  end

  defp data(event) do
    %{id: event.id, name: event.name, date: event.event_date, venue_id: event.venue_id}
  end
end
