defmodule D2CrucibleRoulette.Repo.Migrations.SetupStrats do
  use Ecto.Migration

  def change do
    create table(:strats) do
      add :name, :string
      add :description, :text
      add :author, :string
    end
  end
end
