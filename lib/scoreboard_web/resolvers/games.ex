defmodule ScoreboardWeb.Resolvers.Games do
  def submit_score(%{name: _, total: _, game_id: _} = args, _res), do: Scoreboard.Games.create_score_and_player(args)
  def submit_score(args, _res), do: Scoreboard.Games.create_score(args)
end
