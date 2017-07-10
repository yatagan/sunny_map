# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sunny_map,
  ecto_repos: [SunnyMap.Repo]

# Configures the endpoint
config :sunny_map, SunnyMap.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0kVc4JdiuX5UDESKmMLEteKRS96++lbdrktlKJRiWRB5RrbwrurDYdaRtDpEl8/G",
  render_errors: [view: SunnyMap.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SunnyMap.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
