defmodule D2CrucibleRoulette.Factory do
  use ExMachina.Ecto, repo: D2CrucibleRoulette.Repo
  alias D2CrucibleRoulette.Strats.Strat

  def strat_factory() do
    %Strat{
      name: Faker.Lorem.word(),
      description: Faker.Food.description(),
      author: Faker.Internet.user_name(),
      likes: Faker.random_between(0, 100),
      dislikes: Faker.random_between(0, 100)
    }
  end
end
