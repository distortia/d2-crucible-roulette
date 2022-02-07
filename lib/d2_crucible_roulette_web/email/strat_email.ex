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
    email = System.get_env("EMAIL_ADDRESS") || "nope@example.com"

    sender_email =
      System.get_env("SENDGRID_EMAIL_ADDRESS") || "noreply@d2crucibleroulette.fly.dev"

    new()
    |> to(email)
    |> from({"D2 Crucible Roulette Team", sender_email})
    |> subject("New Strat!")
    |> render_body("strat_email.html", %{strat: strat})
  end
end
