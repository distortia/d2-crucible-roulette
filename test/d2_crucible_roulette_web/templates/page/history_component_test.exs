defmodule D2CrucibleRouletteWeb.HistoryComponentTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias D2CrucibleRouletteWeb.HistoryComponent
  @endpoint D2CrucibleRouletteWeb.Endpoint

  test "renders the history component" do
    history =
      :strat
      |> build_pair()
      |> Enum.map(&[&1.name, &1.description])

    html = render_component(HistoryComponent, history: history)
    [[f_name, f_desc], [s_name, s_desc]] = history

    assert html =~ f_name
    assert html =~ f_desc
    assert html =~ s_name
    assert html =~ s_desc
  end
end
