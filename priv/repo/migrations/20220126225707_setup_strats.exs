defmodule D2CrucibleRoulette.Repo.Migrations.SetupStrats do
  use Ecto.Migration

  def change do
    add table(:strats) do
      add :name, :string
      add :description, :string
      add :author, :string
    end
  end
end
