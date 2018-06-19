defmodule Scoreboard.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scoreboard.Games.{Player, Score}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "games" do
    field(:name, :string)

    has_many(:scores, Score)
    many_to_many(:players, Player, join_through: Score)

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
