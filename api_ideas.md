# This is how the API would be different

Quick overview of how graphql works with Abinsthe.
We read the request body - this will traverse a graph that we have defined
At each "node" in the graph we will perform an operation (can be anything, will often be a DB query)

## RESTful API

```
{:ok, player_x_game_y_scores} = get(conn, "/player/#{player_id}/game/#{game_id}/scores")
{:ok, game_y_high_scores} = get(conn, "/game/#{game_id}/scores?dir=desc,first=10")
```

This means we need a controller with 2 different end points, and we need an endpoint (or query params) for every different piece of data we want.


## GraphQL API

body =
  """
  request {
    player(id=#{player_id}) {
      name
      game(id=#{game_id}) {
        name
        scores(first=10) {
          created_at
          total
        }
      }
    }
    game(id=#{game_id}) {
      scores(first=10, dir=desc) {
        created_at
        total
      }
    }
  }
  """

{:ok, custom_result} = post(conn, "/q", body)

This graph traversal looks like this

This looks much larger, but that's because we are asking for exactly what we want.
As the developer, we just define what is available, and to whom, then the API is dynamic and explorable.

Q -> GraphiQL demo now?

