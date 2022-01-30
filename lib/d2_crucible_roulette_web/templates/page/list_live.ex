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
      <section>
        <%= for strat <- @strats do %>
          <.live_component module={StratComponent} id={"strat-component-#{strat.id}"} strat={strat} />
        <% end %>
      </section>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    strats = Strats.list()
    socket = assign(socket, strats: strats)
    {:ok, socket}
  end

  @doc """
  Like handles the `like` event when clicking the thumbs-up on the given strat
  Sends an update to the component that initiated the event or returns
  nothing if something failed

  Dislike handles the `dislike` event when clicking the thumbs-up on the given strat
  Sends an update to the component that initiated the event or returns
  nothing if something failed
  """
  @impl Phoenix.LiveView
  def handle_event("like", %{"id" => strat_id}, socket) do
    with {:ok, strat} <- Strats.like(strat_id) do
      send_update(StratComponent, id: "strat-component-#{strat_id}", strat: strat)
      {:noreply, socket}
    else
      _ ->
        {:noreply, socket}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("dislike", %{"id" => strat_id}, socket) do
    with {:ok, strat} <- Strats.dislike(strat_id) do
      send_update(StratComponent, id: "strat-component-#{strat_id}", strat: strat)
      {:noreply, socket}
    else
      _ ->
        {:noreply, socket}
    end
  end
end