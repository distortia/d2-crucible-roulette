defmodule D2CrucibleRouletteWeb.StratEmail do
  use Phoenix.Swoosh,
    view: D2CrucibleRouletteWeb.EmailView,
    layout: {D2CrucibleRouletteWeb.EmailView, :email}

  @moduledoc """
  StratEmail is responsible for assembling and sending the email after someone submits a strat
  """

  @doc """
  strat takes in a strat to create and send an email based off of the data provided
  """
  def strat(strat) do
    new()
    |> to("me@example.com")
    |> from({"D2 Crucible Roulette Team", "noreply@d2crucibleroulette.com"})
    |> subject("New Strat!")
    |> render_body("strat_email.html", %{strat: strat})
  end
end
