defmodule D2CrucibleRouletteWeb.PageLiveTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  @endpoint D2CrucibleRouletteWeb.Endpoint

  test "renders home page", ~M{conn} do
    ~M{name, description, author} = insert(:strat)
    {:ok, _view, html} = live(conn, "/")
    assert html =~ "<p class=\"card-header-title strat-name\">#{name}</p>"
    assert html =~ "<div class=\"description\">#{description}</div>"
    assert html =~ "<a href=\"https://discordapp.com/users/#{author}\">#{author}</a>"
    assert html =~ "<span>Roll</span>"
  end

  test "fetches a strat", ~M{conn} do
    ~M{name, description, author} = insert(:strat)
    {:ok, view, _html} = live(conn, "/")

    actual = render_click(view, :fetch)

    assert actual =~ "<p class=\"card-header-title strat-name\">#{name}</p>"
    assert actual =~ "<div class=\"description\">#{description}</div>"
    assert actual =~ "<a href=\"https://discordapp.com/users/#{author}\">#{author}</a>"
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
