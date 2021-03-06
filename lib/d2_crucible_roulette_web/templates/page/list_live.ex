defmodule D2CrucibleRouletteWeb.ListLive do
  use Phoenix.LiveView

  alias D2CrucibleRoulette.Strats
  alias D2CrucibleRouletteWeb.StratComponent

  @moduledoc """
  ListLive is responsible for displaying all of the Strats in the Database
  """

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="container">
      <section class="hero is-dark">
        <div class="hero-body">
          <p class="title">All Strats</p>
        </div>
      </section>
      <section class="mb-5">
        <div class="field has-addons">
          <p class="control">
            <button class={"button is-primary #{is_active(@active, "abc")}"} phx-click="sort" phx-value-type="abc">
              <span class="icon is-small">
                <i class="fas fa-sort-alpha-down"></i>
              </span>
              <span>Asc</span>
            </button>
          </p>
          <p class="control">
            <button class={"button is-primary #{is_active(@active, "cba")}"} phx-click="sort" phx-value-type="cba">
              <span class="icon is-small">
                <i class="fas fa-sort-alpha-down-alt"></i>
              </span>
              <span>Desc</span>
            </button>
          </p>
          <p class="control">
            <button class={"button is-primary #{is_active(@active, "likes")}"} phx-click="sort" phx-value-type="likes">
              <span class="icon is-small">
                <i class="fas fa-sort-numeric-down-alt"></i>
              </span>
              <span>Likes</span>
            </button>
          </p>
          <p class="control">
            <button class={"button is-primary #{is_active(@active, "dislikes")}"} phx-click="sort" phx-value-type="dislikes">
              <span class="icon is-small">
                <i class="fas fa-sort-numeric-down-alt"></i>
              </span>
              <span>Dislikes</span>
            </button>
          </p>
        </div>
      </section>
      <section>
        <%= for strat <- @strats do %>
          <.live_component module={StratComponent} id={"strat-component-#{strat.id}"} strat={strat} like={@like} dislike={@dislike} admin?={@admin?} />
        <% end %>
      </section>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    strats = Strats.list()
    admin? = is_admin?(session)

    socket =
      assign(socket,
        strats: strats,
        active: nil,
        page_title: "D2 Crucible Roulette | All Strats",
        like: "like",
        dislike: "dislike",
        admin?: admin?
      )

    {:ok, socket}
  end

  @doc """
  Sort handles the sorting operation and expects a type to be passed in.
  After sorting the list of strats it is returned to the front end as well as an `active` to toggle which button is active for sorting
  Sort types:
    - "abc" -> alphabetical by strat name
    - "cba" -> reverse alphabetical by strat name
    - "likes" -> descending by strat likes
    - "dislikes" -> descending by strat dislikes
  """
  @impl Phoenix.LiveView
  def handle_event("sort", %{"type" => "abc"}, socket) do
    strats =
      socket.assigns.strats
      |> Enum.sort_by(& &1.name)

    socket = assign(socket, strats: strats, active: "abc")
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("sort", %{"type" => "cba"}, socket) do
    strats =
      socket.assigns.strats
      |> Enum.sort_by(& &1.name, &>/2)

    socket = assign(socket, strats: strats, active: "cba")
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("sort", %{"type" => "likes"}, socket) do
    strats =
      socket.assigns.strats
      |> Enum.sort_by(& &1.likes, &>/2)

    socket = assign(socket, strats: strats, active: "likes")
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("sort", %{"type" => "dislikes"}, socket) do
    strats =
      socket.assigns.strats
      |> Enum.sort_by(& &1.dislikes, &>/2)

    socket = assign(socket, strats: strats, active: "dislikes")
    {:noreply, socket}
  end

  defp is_active(active, button_type) do
    if active == button_type, do: "is-active"
  end

  defp is_admin?(session) do
    user_token = session["user_token"]

    cond do
      is_nil(user_token) ->
        false

      is_nil(D2CrucibleRoulette.Accounts.get_user_by_session_token(user_token)) ->
        false

      true ->
        case D2CrucibleRoulette.Accounts.get_user_by_session_token(user_token) do
          nil -> false
          user -> user.admin
        end
    end
  end
end
