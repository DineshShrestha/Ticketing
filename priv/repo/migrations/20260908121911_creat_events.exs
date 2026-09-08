defmodule Ticketing.Repo.Migrations.CreatEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :event_date, :utc_datetime

      add :venue_id, references(:venues, on_delete: :delete_all)
      timestamps(type: :utc_datetime)
    end

    create index(:events, [:venue_id])
  end
end
