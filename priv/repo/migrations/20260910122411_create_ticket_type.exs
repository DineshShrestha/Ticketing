defmodule Ticketing.Repo.Migrations.CreateTicketTypes do
  use Ecto.Migration

  def change do
    create table(:ticket_types) do
      add :name, :string
      add :price, :integer
      add :quantity, :integer
      add :event_id, references(:events, on_delete: :delete_all)
      timestamps(type: :utc_datetime)
    end
  end
end
