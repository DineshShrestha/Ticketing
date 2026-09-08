defmodule Ticketing.Venues.Venue do
  import Ecto.Changeset
  use Ecto.Schema

  schema "venues" do
    field :name, :string
    field :address, :string
    field :capacity, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(venue, attrs) do
    venue
    |> cast(attrs, [:name, :address, :capacity])
    |> validate_required([:name, :address, :capacity])
  end
end
