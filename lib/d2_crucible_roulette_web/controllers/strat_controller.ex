defmodule D2CrucibleRouletteWeb.StratController do
  use Phoenix.Controller
  alias D2CrucibleRoulette.Strats

  def edit(conn, %{"id" => id}) do
    strat = Strats.get(id)
    changeset = Strats.change(strat)

    conn
    |> render("edit.html",
      changeset: changeset,
      id: id,
      page_title: "D2 Crucible Roulette | Edit Strat"
    )
  end

  def update(conn, %{"id" => id, "strat" => params}) do
    strat = Strats.get(id)

    case Strats.update(strat, params) do
      {:ok, strat} ->
        changeset = Strats.change(strat)

        conn
        |> put_flash(:info, "Strat updated")
        |> render("edit.html", changeset: changeset, id: id)

      {:error, changeset} ->
        conn
        |> put_flash(:error, changeset.errors)
        |> render("edit.html")
    end
  end

  def new(conn, _params) do
    render(conn, "new.html",
      changeset: Strats.change(),
      page_title: "D2 Crucible Roulette | New Strat"
    )
  end

  def create(conn, %{"strat" => strat}) do
    case Strats.add(strat) do
      {:ok, strat} ->
        conn
        |> put_flash(:info, "Strat created")
        |> redirect(to: "/strat/#{strat.id}")

      {:error, changeset} ->
        conn
        |> put_flash(:error, changeset.error)
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Strats.delete(id) do
      {:ok, _strat} ->
        conn
        |> put_flash(:info, "Strat deleted")
        |> redirect(to: "/strats")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Could not delete strat")
        |> render("edit.html", changeset: changeset, id: id)
    end
  end
end
