defmodule Ticketing.Events do
  alias Ticketing.Events.Event
  import Ecto.Query, warn: false
  alias Ticketing.Repo

  def get_event!(id) do
    Repo.get!(Event, id)
  end

  def list_events() do
    Repo.all(Event)
  end

  def create_event(attrs) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def update_event(event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  def delete_event(event) do
    Repo.delete(event)
  end

  def change_event(event, attrs) do
    event
    |> Event.changeset(attrs)
  end
end
