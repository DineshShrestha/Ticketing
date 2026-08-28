defmodule Ticketing.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ticketing.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        event_date: ~U[2026-08-27 06:32:00Z],
        name: "some name"
      })
      |> Ticketing.Events.create_event()

    event
  end
end
