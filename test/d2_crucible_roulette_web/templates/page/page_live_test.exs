defmodule D2CrucibleRouletteWeb.PageLiveTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  @endpoint D2CrucibleRouletteWeb.Endpoint

  test "renders home page", ~M{conn} do
    ~M{name, description, author} = insert(:strat)
    {:ok, _view, html} = live(conn, "/")
    assert html =~ name
    assert html =~ description
    assert html =~ author
    assert html =~ "<span>Roll</span>"
  end

  test "fetches a strat", ~M{conn} do
    ~M{name, description, author} = insert(:strat)
    {:ok, view, _html} = live(conn, "/")

    actual = render_click(view, :fetch)

    assert actual =~ name
    assert actual =~ description
    assert actual =~ author
  end

  test "a strat can be liked", ~M{conn} do
    strat = insert(:strat)
    {:ok, view, _html} = live(conn, "/")
    render_click(view, :fetch)
    assert render_click(view, :like, %{"id" => strat.id}) =~ "<span>#{strat.likes + 1}</span>"
  end

  test "a strat can be disliked", ~M{conn} do
    strat = insert(:strat)
    {:ok, view, _html} = live(conn, "/")
    render_click(view, :fetch)

    assert render_click(view, :dislike, %{"id" => strat.id}) =~
             "<span>#{strat.dislikes + 1}</span>"
  end
end
