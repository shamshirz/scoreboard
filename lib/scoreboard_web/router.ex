defmodule ScoreboardWeb.Router do
  use ScoreboardWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/" do
    pipe_through(:api)

    forward("/api", Absinthe.Plug, schema: ScoreboardWeb.Schema)

    forward(
      "/",
      Absinthe.Plug.GraphiQL,
      schema: ScoreboardWeb.Schema,
      interface: :simple
    )
  end
end
