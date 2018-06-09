defmodule ScoreboardWeb.Router do
  use ScoreboardWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ScoreboardWeb do
    pipe_through :api
  end
end
