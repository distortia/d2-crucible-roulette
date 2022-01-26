defmodule D2CrucibleRouletteWeb.PageController do
  use D2CrucibleRouletteWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
