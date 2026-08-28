defmodule Ticketing.VenuesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ticketing.Venues` context.
  """

  @doc """
  Generate a venue.
  """
  def venue_fixture(attrs \\ %{}) do
    {:ok, venue} =
      attrs
      |> Enum.into(%{
        address: "some address",
        capacity: 42,
        name: "some name"
      })
      |> Ticketing.Venues.create_venue()

    venue
  end
end
