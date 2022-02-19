defmodule D2CrucibleRouletteWeb.StratControllerTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true

  describe "StratController" do
    setup ~M{conn} do
      user = insert(:user, admin: true)
      strat = insert(:strat)
      conn = log_in_user(conn, user)
      ~M{conn, strat}
    end

    test "redirects if user is not an admin" do
      conn = build_conn()
      conn = get(conn, Routes.strat_path(conn, :edit, 1))
      assert redirected_to(conn) == Routes.user_session_path(conn, :new)
    end

    test "can render the edit page", ~M{conn, strat} do
      conn = get(conn, Routes.strat_path(conn, :edit, strat.id))
      assert html_response(conn, 200) =~ "Editing Strat"
    end

    test "can update a strat", ~M{conn, strat} do
      author = "newauthor#1234"

      updates =
        strat
        |> Map.from_struct()
        |> Map.merge(%{"author" => author})

      conn = put(conn, Routes.strat_path(conn, :update, strat.id), %{"strat" => updates})

      assert get_flash(conn, :info) == "Strat updated"
      assert html_response(conn, 200) =~ author
    end

    test "can render the new strat page for admins", ~M{conn} do
      conn =
        conn
        |> get(Routes.strat_path(conn, :new))
        |> html_response(200)

      assert conn =~ "New Strat"
    end

    test "can submit a new strat", ~M{conn} do
      strat = build(:raw_strat)

      assert conn
             |> post(Routes.strat_path(conn, :create), %{"strat" => strat})
             |> redirected_to() =~ "/strat/"
    end

    test "can delete a strat", ~M{conn, strat} do
      conn = delete(conn, Routes.strat_path(conn, :delete, strat.id))
      assert get_flash(conn, :info) == "Strat deleted"
      assert redirected_to(conn) == "/strats"
    end
  end
end
