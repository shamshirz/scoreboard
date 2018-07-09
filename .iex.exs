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
  3 different root nodes
  expects 3 requests, but what if we use a dataloader to batch these requests?
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


  # Example code from the website!
  # TODO - show this in a slide
  # source = Dataloader.Ecto.new(MyApp.Repo)

  # # setup the loader
  # loader = Dataloader.new |> Dataloader.add_source(:db, source)

  # # load some things
  # loader =
  #   loader
  #   |> Dataloader.load(:db, Organization, 1)
  #   |> Dataloader.load_many(:db, Organization, [4, 9])

  # # actually retrieve them
  # loader = Dataloader.run(loader)

  # # Now we can get whatever values out we want
  # organizations = Dataloader.get_many(loader, :db, Organization, [1,4])


  # Demo?
  # > iex -S mix
  # DataloaderExample.count_requests()
  # Show number of requests, look at how it automatically batches the player requests

end