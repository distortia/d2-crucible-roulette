defmodule D2CrucibleRouletteWeb.ListLiveTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias D2CrucibleRouletteWeb.StratComponent
  @endpoint D2CrucibleRouletteWeb.Endpoint

  test "renders strats page", ~M{conn} do
    ~M{name, description, author} = insert(:strat)
    {:ok, _view, html} = live(conn, "/strats")
    assert html =~ name
    assert html =~ description
    assert html =~ author
  end

  test "a strat can be liked", ~M{conn} do
    strat = insert(:strat)
    {:ok, view, _html} = live(conn, "/strats")
    render_click(view, :like, %{"id" => strat.id})
    assert render(view) =~ "<span>#{strat.likes + 1}</span>"
  end

  test "a strat can be disliked", ~M{conn} do
    strat = insert(:strat)
    {:ok, view, _html} = live(conn, "/strats")
    render_click(view, :dislike, %{"id" => strat.id})
    assert render(view) =~ "<span>#{strat.dislikes + 1}</span>"
  end
end
