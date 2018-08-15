alias Scoreboard.Games

defmodule LetMeSee do
  @moduledoc """
  Open N+1 in a terminal
  Open regular in another terminal

  mix ecto.reset

  iex -S mix

  cmd+r

  LetMeSee.a_game()

  LetMeSee.some_scores()
  """
  alias Scoreboard.Repo
  alias Scoreboard.Games.{Game, Player}

  @game_id Game |> Repo.get_by!(name: "SuperVirus2") |> Map.get(:id)
  @player_id Player |> Repo.get_by!(name: "Aaron") |> Map.get(:id)

  IO.puts(
    "\nAaron - This is your self from the past. Remember to reset the DB! mix ecto.reset then do setup\n"
  )

  def a_game() do
    request = """
    {
      game(id: "#{@game_id}") {
        id
        name
      }
    }
    """

    IO.puts("The Request:")
    IO.puts(request)

    result = Absinthe.run(request, ScoreboardWeb.Schema)

    IO.puts("\nThe Result:")
    result
  end

  def some_scores() do
    request = """
    {
      game(id: "#{@game_id}") {
        id
        name
        scores {
          id
          total
          player {
            id
            name
          }
        }
      }
    }
    """

    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ScoreboardWeb.Schema)

    IO.inspect(result.data, label: "\nResults", limit: 5)
    "Total Scores found: #{result |> get_in([:data, "game", "scores"]) |> length()}"
  end

  def scores_with_args() do
    request = """
    {
      game(id: "#{@game_id}") {
        id
        name
        scores(limit: 5, player_id: "#{@player_id}") {
          id
          total
          player {
            id
            name
          }
        }
      }
    }
    """

    IO.puts("The Request:")
    IO.puts(request)

    {:ok, result} = Absinthe.run(request, ScoreboardWeb.Schema)

    IO.inspect(result.data, label: "\nResults", limit: 5)
    "Aaron's Scores: #{result |> get_in([:data, "game", "scores"]) |> length()}"
  end
end
