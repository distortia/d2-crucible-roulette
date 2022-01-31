defmodule D2CrucibleRouletteWeb.PageController do
  use Phoenix.Controller
  alias D2CrucibleRoulette.Strats

  def new(conn, _params) do
    changeset = Strats.change()
    render(conn, "new.html", changeset: changeset)
  end

  def submit(conn, %{"strat" => strat}) do
    changeset = Strats.change()

    conn
    |> put_flash(:info, "Thank you for submitting a strat!")
    |> render("new.html", changeset: changeset)
  end
end
