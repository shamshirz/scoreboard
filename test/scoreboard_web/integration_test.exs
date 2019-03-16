defmodule ScoreboardWeb.IntegrationTest do
  use ScoreboardWeb.ConnCase

  alias Scoreboard.Games.{Game, Player, Score}
  alias Scoreboard.Repo

  @query """
  query HighScores($game_id: ID!) {
    game(id: $game_id) {
      id
      name
      scores {
        total
        player {
          name
        }
      }
    }
  }
  """

  describe("Full query") do
    test("routing & vars", %{conn: conn}) do
      game = Repo.insert!(%Game{name: "SuperVirus"})
      player = Repo.insert!(%Player{name: "RJ"})
      Repo.insert!(%Score{game_id: game.id, player_id: player.id, total: 101})

      params = [query: @query, variables: %{"game_id" => game.id}]

      response =
        conn
        |> Phoenix.ConnTest.post("/api", params)
        |> Phoenix.ConnTest.json_response(200)

      assert get_in(response, ["data", "game", "scores"]) |> is_list()
    end
  end

  @query """
  mutation NewScore($game_id: ID!, $name: String!, $total: Int!) {
    submit(game_id: $game_id, name: $name, total: $total) {
      game {
        name
      }
      player {
        name
      }
      total
    }
  }
  """

  describe("Mutations") do
    test("submit with a new player", %{conn: conn}) do
      game = Repo.insert!(%Game{name: "SuperVirus"})
      params = [query: @query, variables: %{"game_id" => game.id, "name" => "RJ", "total" => 101}]

      response =
        conn
        |> Phoenix.ConnTest.post("/api", params)
        |> Phoenix.ConnTest.json_response(200)

      assert "SuperVirus" == get_in(response, ["data", "submit", "game", "name"])
      assert "RJ" == get_in(response, ["data", "submit", "player", "name"])
      assert 101 == get_in(response, ["data", "submit", "total"])
    end
  end
end
