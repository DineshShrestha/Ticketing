defmodule Ticketing.Venues.Venue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "venues" do
    field :name, :string
    field :address, :string
    field :capacity, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(venue, attrs) do
    venue
    |> cast(attrs, [:name, :address, :capacity])
    |> validate_required([:name, :address, :capacity])
  end
end
