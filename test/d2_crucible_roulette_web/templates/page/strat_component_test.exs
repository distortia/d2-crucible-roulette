defmodule D2CrucibleRouletteWeb.StratComponentTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

	alias D2CrucibleRouletteWeb.StratComponent
  @endpoint D2CrucibleRouletteWeb.Endpoint

  test "renders the strat component" do
    strat = insert(:strat)
    html = render_component(StratComponent, strat: strat)

    html =~ strat.name
    html =~ strat.description
    html =~ strat.author
    html =~ "Likes: #{strat.likes}"
    html =~ "Disikes: #{strat.dislikes}"
  end
end
