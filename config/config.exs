# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :gitty,
  ecto_repos: [Gitty.Repo]

# Configures the endpoint
config :gitty, GittyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "m7vL1U7kfMFZzbTrUML4fwiWi5TPI2zpEuq7xp703DbCy/NZLtJvd3DNQ73tc7o5",
  render_errors: [view: GittyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Gitty.PubSub,
  live_view: [signing_salt: "W7qElEaU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
