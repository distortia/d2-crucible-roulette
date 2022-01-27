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

  @doc """
  Fetches a strat by its ID
  """
  def get(strat_id) do
    Repo.get(Strat, strat_id)
  end

  @doc """
  Updates the strat with the given attrs
  """
  def update(strat, attrs) do
    strat
    |> Strat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Fetches a strat by ID and updates the like counter
  """
  def like(strat_id) do
    strat = get(strat_id)

    strat
    |> update(%{likes: strat.likes + 1})
  end

  @doc """
  Fetchs a strat by ID and updates the dislike counter
  """
  def dislike(strat_id) do
    strat = get(strat_id)

    strat
    |> update(%{dislikes: strat.dislikes + 1})
  end
end
