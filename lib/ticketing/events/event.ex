defmodule Ticketing.Events.Event do
  import Ecto.Changeset
  use Ecto.Schema

  schema "events" do
    field :name, :string
    field :event_date, :utc_datetime

    belongs_to :venue, Ticketing.Venues.Venue

    timestamps(type: :utc_datetime)
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :event_date, :venue_id])
    |> validate_required([:name, :event_date, :venue_id])
    |> foreign_key_constraint(:venue_id)
  end
end
