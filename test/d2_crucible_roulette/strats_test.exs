defmodule D2CrucibleRoulette.StratsTest do
	use ExUnit.Case, async: true
	doctest D2CrucibleRoulette.Strats
	alias D2CrucibleRoulette.Strats
  alias D2CrucibleRoulette.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "Strats" do
    test "can be added to the database" do
      strat = %{
        name: Faker.Food.dish(),
        description: Faker.Food.description(),
        author: Faker.App.name()
      }

      assert {:ok, _} = Strats.add(strat)
    end

    test "can be randomly fetched from the database" do
      expected_strat = %{
        name: Faker.Food.dish(),
        description: Faker.Food.description(),
        author: Faker.App.name()
      }
      Strats.add(expected_strat)

      strat = Strats.random()

      assert strat.name == expected_strat.name
      assert strat.description == expected_strat.description
      assert strat.author == expected_strat.author
    end
  end

end
