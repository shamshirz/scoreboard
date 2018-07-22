defmodule ScoreboardWeb.Resolvers.Games do
  def submit_score(args, _res), do: Scoreboard.Games.create_score(args)
end
