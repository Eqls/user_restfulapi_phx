# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :user_restfulapi_phx,
  ecto_repos: [UserRestfulapiPhx.Repo]

# Configures the endpoint
config :user_restfulapi_phx, UserRestfulapiPhxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "807jaizJ6mY8y8yc+PZLPpkWzT/MTX3VTh/s6NJNJV9k9HTSd0moUfCPDfpz2cRF",
  render_errors: [view: UserRestfulapiPhxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UserRestfulapiPhx.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Guardian config
config :user_restfulapi_phx, UserRestfulapiPhx.Guardian,
  issuer: "user_restfulapi_phx",
  secret_key: "4/4xsvduZQqjYfkzaKv0stb4k/bJ86TTJitZuH988eTA9/7jBTj6vOlgfEyHUnZo"

config :stripity_stripe, api_key: "sk_test_TwjeYYui4of25M1zRNORb0mY"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
