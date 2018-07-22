defmodule ScoreboardWeb.Router do
  use ScoreboardWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  forward(
    "/graphiql",
    Absinthe.Plug.GraphiQL,
    schema: ScoreboardWeb.Schema,
    interface: :simple
  )

  forward("/api", Absinthe.Plug, schema: ScoreboardWeb.Schema)
end
