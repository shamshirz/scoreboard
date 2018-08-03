alias Scoreboard.Games

defmodule DataloaderExample do
  alias Scoreboard.Games.Game

  @doc """
  Setup the data loader for our repo
  """
  def dataloader() do
    source = Dataloader.Ecto.new(Scoreboard.Repo)

    Dataloader.new() |> Dataloader.add_source(:games, source)
  end

  @doc """
  The scores key will return a list of scores

  ```
  field(:scores, list_of(:score), resolve: dataloader(:games))
  ```

  We could end up with an N+1 situation resolving the 'player' for each one of those scores.
  Luckily for us, dataloader will handle "batching" those requests using a WHERE…IN clause
  """
  def count_requests() do
    request = """
    {
      game(id: "a60eb72b-13c7-4df5-beb4-0d8f5d26715b") {
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

    Absinthe.run(request, ScoreboardWeb.Schema)
  end
end

defmodule LetMeSee do
  alias Scoreboard.Repo
  alias Scoreboard.Games.Game

  def setup() do
    # 46365fbc-8c75-4f06-af93-183aa7771fa9
    Repo.one(Game |> Ecto.Query.first()).id
  end

  def a_game(id) do
    request = """
    {
      game(id: "#{id}") {
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

  def some_scores(id) do
    request = """
    {
      game(id: "#{id}") {
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

    IO.puts("\nThe Result:")
    result.data
  end
end
