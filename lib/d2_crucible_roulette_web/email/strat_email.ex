defmodule D2CrucibleRouletteWeb.StratEmail do
  use Phoenix.Swoosh,
    view: D2CrucibleRouletteWeb.EmailView,
    layout: {D2CrucibleRouletteWeb.EmailView, :email}

  def strat(strat) do
    new()
    |> to("me@example.com")
    |> from({"D2 Crucible Roulette Team", "noreply@d2crucibleroulette.com"})
    |> subject("New Strat!")
    |> render_body("strat_email.html", %{strat: strat})
  end
end
