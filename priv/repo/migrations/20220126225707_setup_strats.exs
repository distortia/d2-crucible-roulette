defmodule D2CrucibleRoulette.Repo.Migrations.SetupStrats do
  use Ecto.Migration

  def change do
    create table(:strats) do
      add :name, :string
      add :description, :text
      add :author, :string
      add :likes, :integer
      add :dislikes, :integer
    end
  end
end
