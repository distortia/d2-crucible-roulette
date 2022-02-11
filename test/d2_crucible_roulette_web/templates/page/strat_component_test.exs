defmodule D2CrucibleRouletteWeb.StratComponentTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias D2CrucibleRouletteWeb.StratComponent
  @endpoint D2CrucibleRouletteWeb.Endpoint

  test "renders the strat component" do
    strat = insert(:strat)
    html = render_component(StratComponent, strat: strat, like: "like", dislike: "dislike")

    html =~ strat.name
    html =~ strat.description
    html =~ strat.author
    html =~ "Likes: #{strat.likes}"
    html =~ "Disikes: #{strat.dislikes}"
  end

  # This is some fancy setup to test the main page and the strats page as they use the same component
  for route <- ["/", "/strats"] do
    test "a strat can be undisliked after disliking it #{route}", ~M{conn} do
      strat = insert(:strat)
      {:ok, view, _html} = live(conn, unquote(route))
      assert element(view, "#strat-#{strat.id} a[phx-click=dislike]") |> render()
      render_click(view, :dislike, %{"id" => strat.id})

      assert element(view, "#strat-#{strat.id} .strat-dislikes") |> render() =~
               "#{strat.dislikes + 1}"

      assert element(view, "#strat-#{strat.id} a[phx-click=undislike]") |> render()
      render_click(view, :undislike, %{"id" => strat.id})

      assert element(view, "#strat-#{strat.id} .strat-dislikes") |> render() =~
               "#{strat.dislikes}"
    end

    test "a strat can be unliked after liking it #{route}", ~M{conn} do
      strat = insert(:strat)
      {:ok, view, _html} = live(conn, unquote(route))
      assert element(view, "#strat-#{strat.id} a[phx-click=like]") |> render()
      render_click(view, :like, %{"id" => strat.id})
      assert element(view, "#strat-#{strat.id} .strat-likes") |> render() =~ "#{strat.likes + 1}"
      assert element(view, "#strat-#{strat.id} a[phx-click=unlike]") |> render()
      render_click(view, :unlike, %{"id" => strat.id})
      assert element(view, "#strat-#{strat.id} .strat-likes") |> render() =~ "#{strat.likes}"
    end

    test "a strat can be liked #{route}", ~M{conn} do
      strat = insert(:strat)
      {:ok, view, _html} = live(conn, unquote(route))
      render_click(view, :like, %{"id" => strat.id})
      assert element(view, ".card .strat-likes") |> render() =~ "#{strat.likes + 1}"
    end

    test "a strat can be disliked #{route}", ~M{conn} do
      strat = insert(:strat)
      {:ok, view, _html} = live(conn, unquote(route))
      render_click(view, :dislike, %{"id" => strat.id})
      assert element(view, ".card .strat-dislikes") |> render() =~ "#{strat.dislikes + 1}"
    end
  end
end
