defmodule D2CrucibleRouletteWeb.PageControllerTest do
  use D2CrucibleRouletteWeb.ConnCase, async: true
  import Swoosh.TestAssertions

  test "can render the new strat submission page", ~M{conn} do
    conn = get(build_conn(), Routes.page_path(conn, :new))
    assert conn.resp_body =~ "Submit your strat!"
  end

  test "can submit a strat" do
    name = Faker.Lorem.word()
    description = Faker.Food.description()
    author = Faker.Internet.user_name()

    conn =
      post(build_conn(), "/submit", %{
        "strat" => %{name: name, description: description, author: author}
      })

    email =
      D2CrucibleRouletteWeb.StratEmail.strat(%{
        "name" => name,
        "description" => description,
        "author" => author
      })

    Swoosh.Adapters.Test.deliver(email, [])
    assert_email_sent(email)
    assert conn |> get_flash(:info) == "Thank you for submitting a strat!"
  end
end
