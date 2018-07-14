# Scoreboard

The goal of this repo is to be a robust example of [Absinthe](https://github.com/absinthe-graphql/absinthe) and [Dataloder](https://github.com/absinthe-graphql/dataloader) to supplement a getting started guide.

Browser games and leaderboards. You play them, you love them, let's make a server to store some of those scores so you can provide persistence for your players.

# Run it

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`
  * Hit it `um…TODO`


# Write your own

## 1. Phoenix
Make a basic Phoenix app to serve an API only and use UUIDs instead of int Ids.

```
mix phx.new ./scoreboard --no-html --no-brunch --binary-id
```

Very neat, Adds in config: `generators: [binary_id: true]`

More info.
> `mix help phx.new`



## 2. Ecto Schemas
We will auto generate a context to access these Ecto Schemas
> `mix help phx.gen.context`

`Player` and `Game` are many to many, using the `Score` to map them together.

```
mix phx.gen.context Games Player players name:string
mix phx.gen.context Games Game games name:string
mix phx.gen.context Games Score scores total:integer player_id:references:players game_id:references:games
```

Let's make sure it works

> `mix test`

This is nice, but I want to have the associations available on my Structs.
Updating this is pretty easy, we can just replace the foreign binary_ids with the `[has_*, belongs_*]` macros.

In `Scoreboard.Games.Score` Replace

```elixir
field :player_id, :binary_id
field :game_id, :binary_id
```

With

```elixir
belongs_to(:game, Game)
belongs_to(:player, Player)
```

I added the associations to the [Game and Player Schemas](https://github.com/shamshirz/scoreboard/commit/0d403a75d6fdeb06a572c2f2e9a400ac1244db66#diff-1c331c359bcb59c0a55389158b9e40fb) schemas as well.

Test again and make sure everything is still okay

> `mix test`


## 3. Absinthe Setup

### [See how I did it in this commit](https://github.com/shamshirz/scoreboard/commit/8e1f71775da8c6ebd5b0b4b465360e31bd4b9c8a#diff-96d99c98494cf91779455a82a37c4d61)

Your API will revolve around your Absinthe Schema. To get this started we will define some types, eerily similary to Ecto.

The Game Type
```
@desc "A Game"
  object :game do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
end
```

This will define your API and how your incoming document maps to elixir functions.

Your Graph doesn't have to be anything like your DB, but in this case, it is.
This is the defintion for the API. Everything that will be exposed and explorable is defined in our `schema.ex`.

```elixir
query do
  field :game, :game do
    arg(:id, non_null(:id))

    resolve(fn %{id: game_id}, _ ->
      Games.get_game(game_id)
    end)
  end
end
```

### Test it!

```
test("We can query data", context) do
  game = Repo.insert!(%Game{name: "Code Simulator '08"})

  document = """
  {
    game(id: "#{game.id}") {
      id
      name
    }
  }
  """

  result = Absinthe.run(document, ScoreboardWeb.Schema)

  assert {:ok, %{data: data}} = result
  assert get_in(data, ["game", "name"]) == game.name
end
```

## 4. Traversing the Graph

TO SELF - Point out verbosity and repeated simple functions of the normal ecto context & the context with Absinthe


### Step 4 - DataLoader

Point out reduced line count, show a PR maybe.


## Learn more

 Add my own deets here


 Code specific resources

 * [Phx generators](https://hexdocs.pm/phoenix/phoenix_mix_tasks.html)
 * [Absinthe Docs](https://hexdocs.pm/absinthe/overview.html)
 * [phx.new Docs](https://github.com/phoenixframework/phoenix/blob/master/installer/lib/mix/tasks/phx.new.ex)

 Talk resources

 * [Talk guidelines)](https://opensource.com/life/14/1/get-your-conference-talk-submission-accepted])
 * [Elixir Conf Proposal Form)](https://docs.google.com/forms/d/e/1FAIpQLSf4CiP2UtB7Www47yVv592w_kHK4qBwZZpQcMlaQJDvDU7qpg/viewform])
 * [Chad Fowlwer Quote)](https://twitter.com/chadfowler/status/671944358388723712])
 * [Spotify Talk Example)](https://vimeo.com/85490944])
 * [Evan on Storytelling)](https://www.deconstructconf.com/2017/evan-czaplicki-on-storytelling])


The fun stuff
 * [ Absinthe Subscriptions With Annkissam ](https://www.annkissam.com/elixir/alembic/posts/2018/07/13/graphql-subscriptions-connecting-phoenix-applications-with-absinthe-and-websockets.html#an-elixir-graphql-client)