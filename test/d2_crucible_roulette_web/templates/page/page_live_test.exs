defmodule D2CrucibleRouletteWeb.PageLiveTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  @endpoint D2CrucibleRouletteWeb.Endpoint

  test "renders home page", ~M{conn} do
    {:ok, _view, html} = live(conn, "/")
    assert html =~ "<h1>Click the button to fetch a random strat!</h1>"
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
    assert render_click(view, :like, %{"id" => strat.id}) =~ "Likes: 1"
  end

  test "a strat can be disliked", ~M{conn} do
    strat = insert(:strat)
    {:ok, view, _html} = live(conn, "/")
    render_click(view, :fetch)
    assert render_click(view, :dislike, %{"id" => strat.id}) =~ "Dislikes: 1"
  end
end
