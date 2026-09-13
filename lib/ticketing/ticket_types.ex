defmodule Ticketing.TicketTypes do
  import Ecto.Query, warn: false
  alias Ticketing.Repo
  alias Ticketing.TicketTypes.TicketType

  def get_ticket_type!(id) do
    Repo.get!(TicketType, id)
  end

  def list_ticket_types() do
    Repo.all(TicketType)
  end

  def create_ticket_type(attrs) do
    %TicketType{}
    |> TicketType.changeset(attrs)
    |> Repo.insert()
  end

  def update_ticket_type(ticket_type, attrs) do
    ticket_type
    |> TicketType.changeset(attrs)
    |> Repo.update()
  end

  def delete_ticket_type(ticket_type) do
    Repo.delete(ticket_type)
  end

  def change_ticket_type(ticket_type, attrs) do
    ticket_type
    |> TicketType.changeset(attrs)
  end
end
