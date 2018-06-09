defmodule Scoreboard.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :total, :integer
      add :player_id, references(:players, on_delete: :nothing, type: :binary_id)
      add :game_id, references(:games, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:scores, [:player_id])
    create index(:scores, [:game_id])
  end
end
