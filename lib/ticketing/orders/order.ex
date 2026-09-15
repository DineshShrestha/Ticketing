defmodule Ticketing.Orders.Order do
  import Ecto.Changeset
  use Ecto.Schema

  schema "orders" do
    field :status, :string
    field :quantity, :integer
    belongs_to :user, Ticketing.Accounts.User
    belongs_to :ticket_type, Ticketing.TicketTypes.TicketType

    timestamps(type: :utc_datetime)
  end

  def changeset(order, attrs) do
    order
    |> cast(attrs, [:status, :quantity, :user_id, :ticket_type_id])
    |> validate_required([:status, :quantity, :user_id, :ticket_type_id])
    |> validate_number(:quantity, greater_than: 0)
    |> foreign_key_constraint(:ticket_type_id)
    |> foreign_key_constraint(:user_id)
  end
end
