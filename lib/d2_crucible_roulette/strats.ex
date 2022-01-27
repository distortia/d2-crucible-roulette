defmodule D2CrucibleRoulette.Strats do
  import Ecto.Query, only: [from: 2]
  alias D2CrucibleRoulette.Repo
  alias D2CrucibleRoulette.Strats.Strat

  @moduledoc """
  An interface for Strats
  """

  @doc """
    Adds a strat to the database
  """
  def add(strat) do
    %Strat{}
    |> Strat.changeset(strat)
    |> Repo.insert()
  end

  @doc """
  Fetches a random strat from the database
  """
  def random() do
    query =
      from Strat,
      order_by: fragment("RANDOM()")

    query
    |> Repo.all()
    |> List.first()
  end

end
