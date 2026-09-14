defmodule Ticketing.Accounts.UserToken do
  import Ecto.Changeset
  use Ecto.Schema

  schema "user_tokens" do
    field :token, :binary
    field :context, :string
    belongs_to :user, Ticketing.Accounts.User
    timestamps(type: :utc_datetime)
  end

  def changeset(user_token, attrs) do
    user_token
    |> cast(attrs, [:token, :context, :user_id])
    |> validate_required([:token, :context, :user_id])
  end
end
