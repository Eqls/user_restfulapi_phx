defmodule UserRestfulapiPhx.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :user_restfulapi_phx,
    module: UserRestfulapiPhx.Guardian,
    error_handler: UserRestfulapiPhx.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
