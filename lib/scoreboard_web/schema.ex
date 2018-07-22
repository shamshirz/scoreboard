defmodule ScoreboardWeb.Schema do
  use Absinthe.Schema
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias Scoreboard.Games
  alias ScoreboardWeb.Resolvers

  def context(ctx) do
    loader =
      Dataloader.new |> Dataloader.add_source(:games, Games.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  @desc "A Game"
  object :game do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:scores, list_of(:score), resolve: dataloader(:games))
  end

  @desc "A Player"
  object :player do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:scores, list_of(:score), resolve: dataloader(:games))
  end

  @desc "A Score."
  object :score do
    field(:id, non_null(:id))
    field(:total, non_null(:integer))
    field(:player, :player, resolve: dataloader(:games))
    field(:game, :game, resolve: dataloader(:games))
  end

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

  mutation do
    @desc "Submit a score"
    field :submit_score, type: :score do
      arg(:game_id, non_null(:id))
      arg(:player_id, non_null(:id))
      arg(:total, non_null(:integer))

      resolve(&Resolvers.Games.submit_score/2)
    end
  end
end
