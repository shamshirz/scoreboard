defmodule Scoreboard.Games.Score do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scoreboard.Games.{Game, Player}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "scores" do
    field(:total, :integer)
    belongs_to(:game, Game)
    belongs_to(:player, Player)

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:total, :player_id, :game_id])
    |> validate_required([:total, :player_id, :game_id])
  end
end
