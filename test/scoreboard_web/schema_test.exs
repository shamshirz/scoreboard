defmodule Scoreboard.SchemaTest do
  use Scoreboard.DataCase

  alias Scoreboard.Games.{Game, Player, Score}
  alias Scoreboard.Repo

  setup do
    game = Repo.insert!(%Game{name: "Code Simulator '08"})
    player = Repo.insert!(%Player{name: "Aaron"})

    %{game: game, player: player}
  end

  describe("top level queries") do
    test("We can get our fake data", context) do
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

  describe("nested queries") do
    test("We can query associations", context) do
      score = Repo.insert!(%Score{game_id: context.game.id, player_id: context.player.id, total: 101})

      document = """
      {
        game(id: "#{context.game.id}") {
          id
          name
          scores {
            total
            player {
              id
              name
            }
          }
        }
      }
      """

      result = Absinthe.run(document, ScoreboardWeb.Schema)

      assert {:ok, %{data: data}} = result
      assert get_in(data, ["game", "name"]) == context.game.name

      first = fn :get, data, next -> data |> hd() |> next.() end
      assert get_in(data, ["game", "scores", first, "total"]) == score.total
      assert get_in(data, ["game", "scores", first, "player", "name"]) == context.player.name
    end
  end
end
