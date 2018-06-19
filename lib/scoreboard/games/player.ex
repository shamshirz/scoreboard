defmodule Scoreboard.Games.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scoreboard.Games.{Game, Score}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "players" do
    field(:name, :string)

    has_many(:scores, Score)
    many_to_many(:games, Game, join_through: Score)

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
