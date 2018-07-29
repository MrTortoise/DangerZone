# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :danger_zone_ui,
  namespace: DangerZoneUi

# Configures the endpoint
config :danger_zone_ui, DangerZoneUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DmUuMNqU8CH0cdHKewJrla2jKU69kp36F9GxQE41kIN1pFsNFlvZBvESbuwS8H03",
  render_errors: [view: DangerZoneUiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DangerZoneUi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
