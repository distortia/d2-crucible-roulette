defmodule D2CrucibleRoulette.StratsTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true
  alias D2CrucibleRoulette.Strats

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
      expected_strat = insert(:strat)

      strat = Strats.random()

      assert strat.name == expected_strat.name
      assert strat.description == expected_strat.description
      assert strat.author == expected_strat.author
    end

    test "can be liked" do
      ~M{id} = insert(:strat)

      {:ok, strat} = Strats.like(id)

      assert strat.likes == strat.likes
    end

    test "can be disliked" do
      ~M{id} = insert(:strat)

      {:ok, strat} = Strats.dislike(id)

      assert strat.dislikes == strat.dislikes
    end

    test "can be found by id" do
      expected = insert(:strat)

      assert expected == Strats.get(expected.id)
    end

    test "can be updated" do
      strat = insert(:strat)

      assert {:ok, %{name: "New name"}} = Strats.update(strat, %{name: "New name"})
    end

    test "can return all strats" do
      strats = insert_list(10, :strat)

      assert Strats.list() == strats
    end

    test "can return a changeset" do
      assert Strats.change() == Strats.Strat.changeset(%Strats.Strat{}, %{})
    end
  end
end
