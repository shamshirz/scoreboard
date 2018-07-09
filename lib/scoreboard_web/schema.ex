defmodule ScoreboardWeb.Schema do
  use Absinthe.Schema
  alias Scoreboard.Games

  @desc "A Game"
  object :game do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
  end

  @desc "A Player"
  object :player do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
  end

  # @desc "A Score."
  # object :score do
  #   field(:id, non_null(:id))
  #   field(:total, non_null(:integer))
  # end

  query do
    field :game, :game do
      arg(:id, non_null(:id))

      resolve(fn %{id: game_id}, _ ->
        Games.get_game(game_id)
      end)
    end

    field :player, :player do
      arg(:id, non_null(:id))

      resolve(fn %{id: player_id}, _ ->
        Games.get_player(player_id)
      end)
    end
  end
end
