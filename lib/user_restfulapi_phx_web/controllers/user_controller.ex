defmodule UserRestfulapiPhxWeb.UserController do
  use UserRestfulapiPhxWeb, :controller

  alias UserRestfulapiPhx.Accounts
  alias UserRestfulapiPhx.Accounts.User
  alias UserRestfulapiPhx.Guardian

  action_fallback(UserRestfulapiPhxWeb.FallbackController)

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        case Accounts.get_by_email(email) do
          {:ok, %User{} = user} ->
            conn |> render("userjwt.json", %{user: user, jwt: token})

          _ ->
            {:error, "User not found."}
        end

      _ ->
        {:error, :unauthorized}
    end
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> render("userjwt.json", %{user: user, jwt: token})
    end
  end

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = Accounts.get_user!(id)

    with :ok <- user_type(current_user, user),
         {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  @spec user_type(current_user :: %User{}, target_user :: %User{}) ::
          :ok | {:error, :unauthorized}
  defp user_type(%User{id: id}, %User{id: id}), do: :ok
  defp user_type(%User{role: "admin"}, _target_user), do: :ok
  defp user_type(_current_user, _target_user), do: {:error, :unauthorized}

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
