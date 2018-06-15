# Scoreboard

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`


## Taking it one step at a time

### Phoenix
Make a basic Phoenix app to serve an API only

```
mix phx.new ./scoreboard --no-html --no-brunch --binary-id
```

Very neat, Adds in config: `generators: [binary_id: true]`

More info.
> `mix help phx.new`



### Schemas
We will auto generate a context to access these Ecto Schemas
> `mix help phx.gen.context`

`Player` and `Game` are many to many, using the `Score` to map them together.

```
mix phx.gen.context Games Player players name:string
mix phx.gen.context Games Game games name:string
mix phx.gen.context Games Score scores total:integer player_id:references:players game_id:references:games
```

Let's make sure it works

`mix test`

** Note to self, possibly add Player.games & Game.players as `has_many:through`? **


### Absinthe

Add a basic Absinthe Schema - this will define your API and how your incoming document maps to elixir functions

#### Basic Schema

Your Graph doesn't have to be anything like your DB, but in this case, ours will.
This is the defintion for the API. Everything that will be exposed and explorable is defined in our `schema.ex`.

> Show test here

#### Traversing the Graph

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
