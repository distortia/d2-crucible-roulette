defmodule D2CrucibleRouletteWeb.PageLive do
  use Phoenix.LiveView

  alias D2CrucibleRoulette.Strats
  alias D2CrucibleRouletteWeb.{HistoryComponent, StratComponent}

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="section">
      <div class="container">
        <.live_component module={StratComponent} id="strat-component" strat={@strat} />
        <div class="hero is-dark">
          <div class="hero-body is-align-self-center">
            <button class="button is-primary is-medium" phx-click="fetch">
              <span class="icon">
                <i class="fas fa-dice-d20"></i>
              </span>
              <span>Roll</span>
            </button>
          </div>
        </div>
        <.live_component module={HistoryComponent} id="history-component" history={@history} />
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    strat = Strats.random()
    history = push_history(strat, [])
    socket = assign(socket, strat: strat, history: history)
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("fetch", _session, socket) do
    current_history = socket.assigns.history
    strat = Strats.random()
    history = push_history(strat, current_history)
    socket = assign(socket, strat: strat, history: history)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("like", %{"id" => strat_id}, socket) do
    with {:ok, strat} <- Strats.like(strat_id) do
      socket = assign(socket, strat: strat)
      {:noreply, socket}
    else
      _ ->
        {:noreply, socket}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("dislike", %{"id" => strat_id}, socket) do
    with {:ok, strat} <- Strats.dislike(strat_id) do
      socket = assign(socket, strat: strat)
      {:noreply, socket}
    else
      _ ->
        {:noreply, socket}
    end
  end

  defp push_history(strat, history) do
    [[strat.name, strat.description] | history]
  end
end
