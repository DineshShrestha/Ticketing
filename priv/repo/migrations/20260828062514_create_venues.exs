defmodule Ticketing.Repo.Migrations.CreateVenues do
  use Ecto.Migration

  def change do
    create table(:venues) do
      add :name, :string
      add :address, :string
      add :capacity, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
