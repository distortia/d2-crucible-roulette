defmodule D2CrucibleRoulette.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :d2_crucible_roulette

  # If needed to run seeds, we need to copy the strats.csv to the `priv/repo` directory and redeploy
  # To run the seeds we can connect to the fly instance and run `D2CrucibleRoulette.Release.seed`
  # alias D2CrucibleRoulette.Strats
  # def seed() do
  #   NimbleCSV.define(Parser, separator: ",", escape: "\"")

  #   (Application.app_dir(:d2_crucible_roulette, "priv/repo/strats.csv"))
  #   |> File.stream!()
  #   |> Parser.parse_stream()
  #   |> Stream.map(fn [name, description, author] ->
  #     %{
  #       name: :binary.copy(name),
  #       description: :binary.copy(description),
  #       author: :binary.copy(author)
  #     }
  #   end)
  #   |> Stream.each(&Strats.add(&1))
  #   |> Stream.run()
  # end

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
