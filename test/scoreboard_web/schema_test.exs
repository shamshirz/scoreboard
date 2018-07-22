defmodule ScoreboardWeb.SchemaTest do
  use Scoreboard.DataCase

  alias Scoreboard.Games.{Game, Player, Score}
  alias Scoreboard.Repo

  setup do
    game = Repo.insert!(%Game{name: "Code Simulator '08"})
    player = Repo.insert!(%Player{name: "Aaron"})

    %{game: game, player: player}
  end

  describe("top level queries") do
    test("on data", context) do
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
    test("on associations", context) do
      score =
        Repo.insert!(%Score{game_id: context.game.id, player_id: context.player.id, total: 101})

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

    test("passing limit param to scores query", context) do
      Repo.insert!(%Score{game_id: context.game.id, player_id: context.player.id, total: 101})

      document = """
      {
        game(id: "#{context.game.id}") {
          id
          name
          scores(limit: 0) {
            total
          }
        }
      }
      """

      result = Absinthe.run(document, ScoreboardWeb.Schema)

      assert {:ok, %{data: data}} = result
      assert length(get_in(data, ["game", "scores"])) == 0
    end

    test("passing limit & player_id param to scores query", context) do
      sam = Repo.insert!(%Player{name: "Sam"})
      Repo.insert!(%Score{game_id: context.game.id, player_id: context.player.id, total: 101})
      Repo.insert!(%Score{game_id: context.game.id, player_id: sam.id, total: 12})

      document = """
      {
        game(id: "#{context.game.id}") {
          id
          name
          scores(limit: 5, player_id: "#{context.player.id}") {
            total
            player {
              id
            }
          }
        }
      }
      """

      result = Absinthe.run(document, ScoreboardWeb.Schema)

      assert {:ok, %{data: data}} = result

      for %{"player" => %{"id" => id}} = _score <- get_in(data, ["game", "scores"]) do
        assert id == context.player.id
      end
    end
  end

  describe("mutation queries") do
    test("create score", %{game: game, player: player}) do
      score = 37

      document = """
      mutation {
        submitScore(player_id:"#{player.id}", game_id:"#{game.id}", total:#{score}) {
          id
          total
          player {
            name
          }
          game {
            name
          }
        }
      }
      """

      result = Absinthe.run(document, ScoreboardWeb.Schema)

      assert {:ok, %{data: data}} = result
      assert get_in(data, ["submitScore", "game", "name"]) == game.name
      assert get_in(data, ["submitScore", "player", "name"]) == player.name
      assert get_in(data, ["submitScore", "total"]) == score
    end
  end
end
