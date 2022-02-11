defmodule D2CrucibleRouletteWeb.ListLiveTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  @endpoint D2CrucibleRouletteWeb.Endpoint

  test "renders strats page", ~M{conn} do
    ~M{name, description, author} = insert(:strat)
    {:ok, _view, html} = live(conn, "/strats")
    assert html =~ name
    assert html =~ description
    assert html =~ author
  end

  test "strats can be sorted alphabetically by name", ~M{conn} do
    insert(:strat, %{name: "zzzz"})
    insert(:strat, %{name: "aaaaa"})
    {:ok, view, _html} = live(conn, "/strats")
    first = element(view, ".card:nth-child(1) .strat-name") |> render()
    render_click(view, :sort, %{"type" => "abc"})
    refute element(view, ".card:nth-child(1) .strat-name") |> render() == first
  end

  test "strats can be sorted alphabetically by name in reverse", ~M{conn} do
    insert(:strat, %{name: "aaaaa"})
    insert(:strat, %{name: "zzzz"})
    {:ok, view, _html} = live(conn, "/strats")
    first = element(view, ".card:nth-child(1) .strat-name") |> render()
    render_click(view, :sort, %{"type" => "cba"})
    refute element(view, ".card:nth-child(1) .strat-name") |> render() == first
  end

  test "strats can be sorted by likes", ~M{conn} do
    insert(:strat, %{likes: 0})
    insert(:strat, %{likes: 10})
    {:ok, view, _html} = live(conn, "/strats")
    first = element(view, ".card:nth-child(1) .strat-likes") |> render()
    render_click(view, :sort, %{"type" => "likes"})
    refute element(view, ".card:nth-child(1) .strat-likes") |> render() == first
  end

  test "strats can be sorted by dislikes", ~M{conn} do
    insert(:strat, %{dislikes: 1})
    insert(:strat, %{dislikes: 10})
    {:ok, view, _html} = live(conn, "/strats")
    first = element(view, ".card:nth-child(1) .strat-dislikes") |> render()
    render_click(view, :sort, %{"type" => "dislikes"})
    refute element(view, ".card:nth-child(1) .strat-dislikes") |> render() == first
  end
end
