defmodule Scoreboard.Games.Score do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "scores" do
    field :total, :integer
    field :player_id, :binary_id
    field :game_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:total])
    |> validate_required([:total])
  end
end
