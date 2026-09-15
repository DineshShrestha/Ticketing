defmodule Ticketing.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :status, :string
      add :quantity, :integer
      add :user_id, references(:users, on_delete: :delete_all)
      add :ticket_type_id, references(:ticket_types, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:orders, [:user_id])
    create index(:orders, [:ticket_type_id])
  end
end
