defmodule D2CrucibleRouletteWeb.PageLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <h1>Click the button to fetch a random strat!</h1>
    <button phx-click="fetch">Fetch</button>

    <%= if @strat do %>
      <h3><%= @strat.name %></h3>
      <p><%= @strat.description %></p>
      <a href=""><%= @strat.author %></a>
      <div>
        <span>
          Likes: <%= @strat.likes %>
        </span>
        <span>
          Dislikes: <%= @strat.dislikes %>
        </span>
      </div>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    socket = assign(socket, strat: nil)
    {:ok, socket}
  end

  def handle_event("fetch", _session, socket) do
    strat = D2CrucibleRoulette.Strats.random()

    socket = assign(socket, strat: strat)

    {:noreply, socket}
  end
end
