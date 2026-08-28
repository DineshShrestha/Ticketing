defmodule Ticketing.VenuesTest do
  use Ticketing.DataCase

  alias Ticketing.Venues

  describe "venues" do
    alias Ticketing.Venues.Venue

    import Ticketing.VenuesFixtures

    @invalid_attrs %{name: nil, address: nil, capacity: nil}

    test "list_venues/0 returns all venues" do
      venue = venue_fixture()
      assert Venues.list_venues() == [venue]
    end

    test "get_venue!/1 returns the venue with given id" do
      venue = venue_fixture()
      assert Venues.get_venue!(venue.id) == venue
    end

    test "create_venue/1 with valid data creates a venue" do
      valid_attrs = %{name: "some name", address: "some address", capacity: 42}

      assert {:ok, %Venue{} = venue} = Venues.create_venue(valid_attrs)
      assert venue.name == "some name"
      assert venue.address == "some address"
      assert venue.capacity == 42
    end

    test "create_venue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Venues.create_venue(@invalid_attrs)
    end

    test "update_venue/2 with valid data updates the venue" do
      venue = venue_fixture()
      update_attrs = %{name: "some updated name", address: "some updated address", capacity: 43}

      assert {:ok, %Venue{} = venue} = Venues.update_venue(venue, update_attrs)
      assert venue.name == "some updated name"
      assert venue.address == "some updated address"
      assert venue.capacity == 43
    end

    test "update_venue/2 with invalid data returns error changeset" do
      venue = venue_fixture()
      assert {:error, %Ecto.Changeset{}} = Venues.update_venue(venue, @invalid_attrs)
      assert venue == Venues.get_venue!(venue.id)
    end

    test "delete_venue/1 deletes the venue" do
      venue = venue_fixture()
      assert {:ok, %Venue{}} = Venues.delete_venue(venue)
      assert_raise Ecto.NoResultsError, fn -> Venues.get_venue!(venue.id) end
    end

    test "change_venue/1 returns a venue changeset" do
      venue = venue_fixture()
      assert %Ecto.Changeset{} = Venues.change_venue(venue)
    end
  end
end
