defmodule Ticketing.Accounts do
  alias Ticketing.Repo
  import Ecto.Query, warn: false

  alias Ticketing.Accounts.User
  alias Ticketing.Accounts.UserToken

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def list_users() do
    Repo.all(User)
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(user) do
    Repo.delete(user)
  end

  def change_user(user, attrs) do
    user
    |> User.changeset(attrs)
  end

  def register_user(attrs) do
    %User{} |> User.registration_changeset(attrs) |> Repo.insert()
  end

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)

    if User.valid_password?(user, password) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end

  def generate_user_session_token(user) do
    token = :crypto.strong_rand_bytes(32)

    {:ok, _user_token} =
      %UserToken{token: token, context: "session", user_id: user.id}
      |> Repo.insert()

    token
  end

  def get_user_by_session_token(token) do
    user_token = Repo.get_by(UserToken, token: token, context: "session")

    case user_token do
      nil -> nil
      user_token -> Repo.get!(User, user_token.user_id)
    end
  end
end
