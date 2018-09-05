# Scoreboard

## Talk links

* [Live GraphiQL Example](https://damp-beach-31852.herokuapp.com/)
* [2upervirus: Supervirus 2 Beta](https://aaronvotre.com)
* [SylverStudios Games](https://sylverstud.io/s)
* [Conf Bio](https://elixirconf.com/2018/speakers/aaron-votre)
* [Slides](https://docs.google.com/presentation/d/1tvKx9Gj6k5i51-v41fmQ2Go4iZXHDuPAI3eyJpCEX3E/edit?usp=sharing)

The goal of this repo is to be a robust example of [Absinthe](https://github.com/absinthe-graphql/absinthe) and [Dataloder](https://github.com/absinthe-graphql/dataloader) to supplement a getting started guide.

Browser games and leaderboards. You play them, you love them, let's make a server to store some of those scores so you can provide persistence for your players.

# Run it

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`
  * Open graphiql to `http://localhost:4000/`


# Write your own

These are the steps that I went through building this app. They each focus on one chunk of work, but not exactly a single feature. They try to introduce libraries one at a time.

Table of Contents

* [Generate an App](#generate-an-app)
* [Ecto Schemas](#ecto-schemas)
* [Absinthe Setup](#absinthe-setup)
* [Dataloader](#dataloader)
* [Mutations](#mutations)
* [Limit & filter Scores](#limit--filter-scores)
* [Phoenix Routing & Graphiql](#phoenix-routing--graphiql)

## Generate an App
Make a basic Phoenix app to serve an API only and use UUIDs instead of int Ids.

```
mix phx.new ./scoreboard --no-html --no-brunch --binary-id
```

Very neat, Adds in config: `generators: [binary_id: true]`

More info.
> `mix help phx.new`



## Ecto Schemas

We will auto generate a context to access these Ecto Schemas
```bash
mix help phx.gen.context
```

`Player` and `Game` are many to many, using the `Score` to map them together.

```
mix phx.gen.context Games Player players name:string
mix phx.gen.context Games Game games name:string

mix phx.gen.context Games Score scores total:integer player_id:references:players game_id:references:games
```

Let's make sure it works

```bash
mix test
```

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

## Absinthe Setup

[See the diff in this PR](https://github.com/shamshirz/scoreboard/pull/1)

Your API will revolve around your Absinthe `Schema`. To get this started we will define some types, eerily similary to Ecto.

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
There are some informative tests [Here](https://github.com/shamshirz/scoreboard/pull/1).

## Dataloader

Dataloader takes care of batching our queries for us. It dramatically reduces code length and complexity too.

[Dataloader PR](https://github.com/shamshirz/scoreboard/pull/3/files)


## Mutations

When we change data via Absinthe, these are called Mutations. Much like the "root query", we have a "root mutation". After the mutation, you can explore the graph and resolve the same way we do in queries.

[Add our first mutation](https://github.com/shamshirz/scoreboard/pull/8)

```elixir
mutation do
  @desc "Submit a score"
  field :submit_score, type: :score do
    arg(:game_id, non_null(:id))
    arg(:player_id, non_null(:id))
    arg(:total, non_null(:integer))

    resolve(&Resolvers.Games.submit_score/2)
  end
end
```


## Limit & filter Scores

Allow optional args on the `scores` key of our `game` type.

```elixir
field :scores, list_of(:score) do
  arg(:limit, :integer)
  arg(:player_id, :id)
  resolve(dataloader(:games))
end
```

And update `Scoreboard.Games.query/2` to handle params

```elixir
def query(Score, params) do
  params
  |> Map.to_list()
  |> Enum.reduce(Score, &apply_param/2)
end

def apply_param({:limit, num}, queryable), do: queryable |> limit(^num)
```

[Games.query/2 PR here](https://github.com/shamshirz/scoreboard/pull/9/files)


## Phoenix Routing & Graphiql

Now that we can provide something useful, let's try and running the server. We just need to add a route that goes to our Absinthe schema.

[Phoenix Route PR](https://github.com/shamshirz/scoreboard/pull/9)

`ScoreboardWeb.Router`
```elixir
forward(
    "/",
    Absinthe.Plug.GraphiQL,
    schema: ScoreboardWeb.Schema,
    interface: :simple
  )

forward("/api", Absinthe.Plug, schema: ScoreboardWeb.Schema)
```

Once the router is updated we can explore our absinthe schema using [Graphiql](https://github.com/graphql/graphiql). It's a UI tool that you can view schemas and write queries with. There are download docs in the repo, but I installed it through `brew`.

Start the Server
```bash
mix phx.server
```

[Open Graphiql locally](http://localhost:4000/)

# Heroku

```bash
heroku config:set x="y" # Set env Vars for runtime (not compile-time)
git push heroku master # Deploy
heroku open #Open browser to app graphiql interface!
heroku run "POOL_SIZE=2 mix hello.task" #Run a mix task, & limit db connections

# Postgres stuff
heroku pg:info # get db_name from add-on field.
heroku pg:reset DB_NAME # Didn't need
heroku run MIX_ENV=prod mix ecto.migrate
heroku run MIX_ENV=prod mix run priv/repo/seeds.exs
```
# Learn more

 Code specific resources

 * [Phx generators](https://hexdocs.pm/phoenix/phoenix_mix_tasks.html)
 * [Absinthe Docs](https://hexdocs.pm/absinthe/overview.html)
 * [phx.new Docs](https://github.com/phoenixframework/phoenix/blob/master/installer/lib/mix/tasks/phx.new.ex)

 Talk resources

 * [Talk guidelines](https://opensource.com/life/14/1/get-your-conference-talk-submission-accepted])
 * [Elixir Conf Proposal Form](https://docs.google.com/forms/d/e/1FAIpQLSf4CiP2UtB7Www47yVv592w_kHK4qBwZZpQcMlaQJDvDU7qpg/viewform])
 * [Chad Fowlwer Quote](https://twitter.com/chadfowler/status/671944358388723712])
 * [Spotify Talk Example](https://vimeo.com/85490944])
 * [Evan on Storytelling](https://www.deconstructconf.com/2017/evan-czaplicki-on-storytelling])


The fun stuff
 * [ Absinthe Subscriptions With Annkissam ](https://www.annkissam.com/elixir/alembic/posts/2018/07/13/graphql-subscriptions-connecting-phoenix-applications-with-absinthe-and-websockets.html#an-elixir-graphql-client)
 * [ Subscription Guide ](https://hexdocs.pm/absinthe/subscriptions.html)