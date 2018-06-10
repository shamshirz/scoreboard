defmodule ScoreboardWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Schema.Notation

  # Example data.
  # A game, a player, and a score
  @db %{
    games: %{"1" => %{id: "1", name: "Code Simulator '08"}},
    players: %{"1" => %{id: "1", name: "Aaron"}},
    scores: %{"1" => %{id: "1234", total: 100}}
  }

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
        {:ok, @db.games[game_id]}
      end)
    end

    field :player, :player do
      arg(:id, non_null(:id))

      resolve(fn %{id: player_id}, _ ->
        {:ok, @db.players[player_id]}
      end)
    end
  end
end
