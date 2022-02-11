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

  # This test is flakey :(
  # test "a strat will not be duplicated", ~M{conn} do
  #   insert(:strat, %{name: "one"})
  #   insert(:strat, %{name: "two"})
  #   insert(:strat, %{name: "three"})
  #   {:ok, view, _html} = live(conn, "/")
  #   first_strat = element(view, ".strat-name") |> render()
  #   render_click(view, :fetch)
  #   refute element(view, ".strat-name") |> render() == first_strat
  # end
end
