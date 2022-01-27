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

    test "can be liked" do
      {:ok, %{id: id}} = Strats.add(%{
        name: Faker.Food.dish(),
        description: Faker.Food.description(),
        author: Faker.App.name()
      })

      {:ok, strat} = Strats.like(id)

      assert strat.likes == 1
    end

    test "can be disliked" do
      {:ok, %{id: id}} = Strats.add(%{
        name: Faker.Food.dish(),
        description: Faker.Food.description(),
        author: Faker.App.name()
      })

      {:ok, strat} = Strats.dislike(id)

      assert strat.dislikes == 1
    end

    test "can be found by id" do
      {:ok, expected} = Strats.add(%{
        name: Faker.Food.dish(),
        description: Faker.Food.description(),
        author: Faker.App.name()
      })

      assert expected == Strats.get(expected.id)
    end

    test "can be updated" do
      {:ok, strat} = Strats.add(%{
        name: Faker.Food.dish(),
        description: Faker.Food.description(),
        author: Faker.App.name()
      })

      assert {:ok, %{name: "New name"}} = Strats.update(strat, %{name: "New name"})
    end
  end

end
