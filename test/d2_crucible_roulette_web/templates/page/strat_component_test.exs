defmodule D2CrucibleRouletteWeb.StratComponentTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias D2CrucibleRouletteWeb.StratComponent
  @endpoint D2CrucibleRouletteWeb.Endpoint

  describe "Strat Components" do
    setup ~M{conn} do
      strat = insert(:strat)
      {:ok, view, _html} = live(conn, "/")
      ~M{strat, view}
    end

    test "can be rendered", ~M{strat} do
      html =
        render_component(StratComponent,
          id: "strat-#{strat.id}",
          strat: strat,
          like: "like",
          dislike: "dislike",
          admin?: false
        )

      assert html =~ "<p class=\"card-header-title strat-name\">#{strat.name}</p>"
      assert html =~ "<div class=\"description\">#{strat.description}</div>"

      assert html =~
               "<a href=\"https://discordapp.com/users/#{strat.author}\">#{strat.author}</a>"

      assert html =~ "<span class=\"strat-likes\">#{strat.likes}</span>"
      assert html =~ "<span class=\"strat-dislikes\">#{strat.dislikes}</span>"

      refute html =~
               "<a class=\"button is-warning mr-1 mt-1\" href=\"/strat/#{strat.id}\">Edit</a>"
    end

    test "can be rendered for admins", ~M{strat} do
      html =
        render_component(StratComponent,
          id: "strat-#{strat.id}",
          strat: strat,
          like: "like",
          dislike: "dislike",
          admin?: true
        )

      assert html =~
               "<a class=\"button is-warning mr-1 mt-1\" href=\"/strat/#{strat.id}\">Edit</a>"
    end

    test "can be liked", ~M{strat, view} do
      view
      |> like_strat(strat)

      assert has_element?(view, "#strat-#{strat.id} .strat-likes", "#{strat.likes + 1}")
    end

    test "can be unliked", ~M{strat, view} do
      view
      |> like_strat(strat)
      |> like_strat(strat)

      assert has_element?(view, "#strat-#{strat.id} .strat-likes", "#{strat.likes}")
    end

    test "can be disliked", ~M{strat, view} do
      view
      |> dislike_strat(strat)

      assert has_element?(view, "#strat-#{strat.id} .strat-dislikes", "#{strat.dislikes + 1}")
    end

    test "can be undisliked", ~M{strat, view} do
      view
      |> dislike_strat(strat)
      |> dislike_strat(strat)

      assert has_element?(view, "#strat-#{strat.id} .strat-dislikes", "#{strat.dislikes}")
    end
  end

  defp like_strat(view, strat) do
    view
    |> element("#strat-#{strat.id} .like-button")
    |> render_click()

    view
  end

  defp dislike_strat(view, strat) do
    view
    |> element("#strat-#{strat.id} .dislike-button")
    |> render_click()

    view
  end
end
