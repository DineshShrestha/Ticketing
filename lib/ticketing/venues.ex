defmodule Ticketing.Venues do
  import Ecto.Query, warn: false

  alias Ticketing.Venues.Venue
  alias Ticketing.Repo

  def get_venue!(id) do
    Repo.get!(Venue, id)
  end

  def list_venues() do
    Repo.all(Venue)
  end

  def create_venue(attrs) do
    %Venue{}
    |> Venue.changeset(attrs)
    |> Repo.insert()
  end

  def update_venue(venue, attrs) do
    venue
    |> Venue.changeset(attrs)
    |> Repo.update()
  end

  def delete_venue(venue) do
    Repo.delete(venue)
  end

  def change_venue(venue, attrs) do
    venue
    |> Venue.changeset(attrs)
  end
end
