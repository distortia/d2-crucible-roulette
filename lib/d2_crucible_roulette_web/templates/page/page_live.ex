defmodule D2CrucibleRouletteWeb.PageLive do
  use Phoenix.LiveView

  alias D2CrucibleRoulette.Strats
  alias D2CrucibleRouletteWeb.StratComponent

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <h1>Click the button to fetch a random strat!</h1>
    <button phx-click="fetch">Fetch</button>
    <%= if @strat do %>
      <.live_component module={StratComponent} id="strat-component" strat={@strat} />
    <% end %>
    <hr>
    <h3>History</h3>
    <%= for [name, description] <- @history do %>
      <div>
        <h4>
          <%= name %>
        </h4>
        <p><%= description %></p>
      </div>
    <% end %>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket = assign(socket, strat: nil, history: [])
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("fetch", _session, socket) do
    current_history = socket.assigns.history
    strat = Strats.random()
    history = [[strat.name, strat.description] | current_history]
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
end
