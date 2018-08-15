# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Scoreboard.Repo.insert!(%Scoreboard.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Scoreboard.Repo
alias Scoreboard.Games.{Game, Player, Score}

aaron = Repo.insert!(%Player{name: "Aaron"})
sam = Repo.insert!(%Player{name: "Sam"})
rj = Repo.insert!(%Player{name: "rj"})

sv_2 = Repo.insert!(%Game{name: "SuperVirus2"})
tmm = Repo.insert!(%Game{name: "Trump Money Maker"})

players = [aaron, sam, rj]

scores =
  for _ <- 1..30 do
    data = %{
      game_id: sv_2.id,
      player_id: Enum.random(players).id,
      total: :rand.uniform(100),
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    }
  end

Repo.insert_all(Score, scores)
