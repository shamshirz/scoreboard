# Scoreboard

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`


## How to recreate me

### Step 1 - Phoenix
** mix help phx.new **

`mix phx.new ./scoreboard --no-html --no-brunch --binary-id`

Very neat, in config: `generators: [binary_id: true]`

In the future `… --no-webpack`
(phx.new Docs)[https://github.com/phoenixframework/phoenix/blob/master/installer/lib/mix/tasks/phx.new.ex]


### Step 2 - Schemas
** mix help phx.gen.context **
We will auto generate a context to access these Ecto Schemas

`Player` and `Game` are many to many, using the `Score` to map them together.

```
mix phx.gen.context Games Player players name:string
mix phx.gen.context Games Game games name:string
mix phx.gen.context Games Score scores total:integer player_id:references:players game_id:references:games
```

Easy to create, sure is a lot of boilerplate though.

Let's make sure it works

`mix test`

** Note to self, possibly add Player.games & Game.players as `has_many:through`? **


### Step 3 - Absinthe

Point out verbosity and repeated simple functions of the normal ecto context & the context with Absinthe

### Step 4 - DataLoader

Point out reduced line count, show a PR maybe.


## Learn more

 Add my own deets here