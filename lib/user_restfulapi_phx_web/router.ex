defmodule UserRestfulapiPhxWeb.Router do
  use UserRestfulapiPhxWeb, :router

  alias UserRestfulapiPhx.Guardian

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    # plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :jwt_authenticated do
    plug(Guardian.AuthPipeline)
  end

  scope "/api", UserRestfulapiPhxWeb do
    # Use the default browser stack
    pipe_through(:api)

    post("/sign_up", UserController, :create)
    post("/sign_in", UserController, :sign_in)
    resources("/stripe", StripeController, only: [:create, :delete])
  end

  scope "/api", UserRestfulapiPhxWeb do
    pipe_through([:api, :jwt_authenticated])

    put("/users", UserController, :update)
    get("/current_user", UserController, :show)
  end

  # Other scopes may use custom stacks.
  # scope "/api", UserRestfulapiPhxWeb do
  #   pipe_through :api
  # end
end
