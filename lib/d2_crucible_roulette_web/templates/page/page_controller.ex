defmodule D2CrucibleRouletteWeb.PageController do
  use Phoenix.Controller
  alias D2CrucibleRoulette.{Mailer, Strats}
  alias D2CrucibleRouletteWeb.StratEmail

  @page_title "D2 Crucible Roulette | New Strat"

  @doc """
  New renders the new.html for the Strat Submission page
  """
  def new(conn, _params) do
    changeset = Strats.change()
    render(conn, "new.html", changeset: changeset, page_title: @page_title)
  end

  @doc """
  Submit handles the POST from the new strat submission form. It delivers an email and thanks the user for their submission
  """
  def submit(conn, %{"strat" => strat}) do
    changeset = Strats.change()

    strat
    |> StratEmail.strat()
    |> Mailer.deliver()

    conn
    |> put_flash(:info, "Thank you for submitting a strat!")
    |> render("new.html", changeset: changeset, page_title: @page_title)
  end
end
