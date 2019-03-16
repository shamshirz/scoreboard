use Mix.Config

config :scoreboard, ScoreboardWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: "damp-beach-31852.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

config :scoreboard, Scoreboard.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

# Do not print debug messages in production
config :logger, level: :info

config :cors_plug,
  origin: ["https://aaronvotre.com/", "https://sylverstudios.dev/"],
  max_age: 86400,
  methods: ["GET", "POST"]
