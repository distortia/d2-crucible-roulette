defmodule D2CrucibleRouletteWeb.PageControllerTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true

  test "can render the new strat submission page", ~M{conn} do
    conn = get(build_conn(), Routes.page_path(conn, :new))
    assert conn.resp_body =~ "Submit your strat!"
  end

  test "can submit a strat" do
    conn = post(build_conn(), "/submit", name: "john", description: "doe", author: "test#1234")
    assert conn |> get_flash(:info) == "Thank you for submitting a strat!"
  end
end
