defmodule D2CrucibleRoulette.Strats do
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

end
