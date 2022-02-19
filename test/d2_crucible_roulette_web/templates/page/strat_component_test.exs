defmodule D2CrucibleRouletteWeb.StratComponentTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias D2CrucibleRouletteWeb.StratComponent
  @endpoint D2CrucibleRouletteWeb.Endpoint

  test "renders the strat component" do
    strat = insert(:strat)

    html =
      render_component(StratComponent,
        strat: strat,
        like: "like",
        dislike: "dislike",
        admin?: false
      )

    assert html =~ "<p class=\"card-header-title strat-name\">#{strat.name}</p>"
    assert html =~ "<div class=\"description\">#{strat.description}</div>"
    assert html =~ "<a href=\"https://discordapp.com/users/#{strat.author}\">#{strat.author}</a>"
    assert html =~ "<span class=\"strat-likes\">#{strat.likes}</span>"
    assert html =~ "<span class=\"strat-dislikes\">#{strat.dislikes}</span>"
    refute html =~ "<a class=\"button is-warning mr-1 mt-1\" href=\"/strat/#{strat.id}\">Edit</a>"
  end

  test "renders the strat component as an admin" do
    strat = insert(:strat)

    html =
      render_component(StratComponent, strat: strat, like: "like", dislike: "dislike", admin?: true)

    assert html =~ "<a class=\"button is-warning mr-1 mt-1\" href=\"/strat/#{strat.id}\">Edit</a>"
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
