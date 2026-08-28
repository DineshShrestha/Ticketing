defmodule Ticketing.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :event_date, :utc_datetime
    field :venue_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :event_date])
    |> validate_required([:name, :event_date])
  end
end
