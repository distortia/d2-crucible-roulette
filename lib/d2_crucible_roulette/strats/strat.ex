defmodule D2CrucibleRoulette.Strats.Strat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "strats" do
    field :name, :string
    field :description, :string
    field :author, :string
    field :likes, :integer, default: 0
    field :dislikes, :integer, default: 0
  end

  def changeset(strat, attrs) do
    strat
    |> cast(attrs, [:name, :description, :author])
    |> validate_required([:name, :description, :author])
  end
end
