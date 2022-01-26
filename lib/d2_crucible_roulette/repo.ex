defmodule D2CrucibleRoulette.Repo do
  use Ecto.Repo,
    otp_app: :d2_crucible_roulette,
    adapter: Ecto.Adapters.Postgres
end
