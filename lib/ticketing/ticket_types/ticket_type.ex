defmodule Ticketing.TicketTypes.TicketType do
  import Ecto.Changeset
  use Ecto.Schema

  schema "ticket_types" do
    field :name, :string
    field :price, :integer
    field :quantity, :integer

    belongs_to :event, Ticketing.Events.Event
    timestamps(type: :utc_datetime)
  end

  def changeset(ticket_type, attrs) do
    ticket_type
    |> cast(attrs, [:name, :price, :quantity, :event_id])
    |> validate_required([:name, :price, :quantity, :event_id])
    |> foreign_key_constraint(:event_id)
  end
end
