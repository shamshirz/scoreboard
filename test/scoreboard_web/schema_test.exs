defmodule Scoreboard.SchemaTest do
  use Scoreboard.DataCase

  alias Scoreboard.Games.{Game, Player}
  alias Scoreboard.Repo

  setup do
    game = Repo.insert!(%Game{name: "Code Simulator '08"})
    player = Repo.insert!(%Player{name: "Aaron"})

    %{game: game, player: player}
  end

  describe "scores" do
    test "We can get our fake data", context do
      document = """
      {
        game(id: "#{context.game.id}") {
          id
          name
        }
        player(id: "#{context.player.id}") {
          id
          name
        }
      }
      """

      result = Absinthe.run(document, ScoreboardWeb.Schema)

      assert {:ok, %{data: data}} = result
      assert get_in(data, ["game", "name"]) == context.game.name
      assert get_in(data, ["player", "name"]) == context.player.name
    end
  end
end
