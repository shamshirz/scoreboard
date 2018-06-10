defmodule Scoreboard.GamesTest do
  use Scoreboard.DataCase

  alias Scoreboard.Games

  describe "scores" do
    alias Scoreboard.Games.Score

    @request_body """
    {
      game(id: "1") {
        id
        name
      }
      player(id: "1") {
        id
        name
      }
    }
    """

    test "We can get our fake data" do
      result =
        Absinthe.run(@request_body, ScoreboardWeb.Schema) |> IO.inspect(label: "API response")

      assert {:ok, %{data: data}} = result
      assert get_in(data, ["game", "name"]) == "Code Simulator '08"
      assert get_in(data, ["player", "name"]) == "Aaron"
    end
  end
end
