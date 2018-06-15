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
alias Scoreboard.Games
alias Scoreboard.Games.{Game, Player, Score}

aaron = Repo.insert!(%Player{name: "Aaron"})
sam = Repo.insert!(%Player{name: "Sam"})
rj = Repo.insert!(%Player{name: "rj"})

code_simulator = Repo.insert!(%Game{name: "Code Simulator '08"})
risk = Repo.insert!(%Game{name: "Risk"})

Repo.insert!(%Score{game_id: code_simulator.id, player_id: aaron.id, total: 101})
Repo.insert!(%Score{game_id: code_simulator.id, player_id: sam.id, total: 50})
Repo.insert!(%Score{game_id: code_simulator.id, player_id: rj.id, total: 35})

Repo.insert!(%Score{game_id: risk.id, player_id: aaron.id, total: 2})
Repo.insert!(%Score{game_id: risk.id, player_id: sam.id, total: 8})
Repo.insert!(%Score{game_id: risk.id, player_id: rj.id, total: 13})
