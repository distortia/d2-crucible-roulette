defmodule D2CrucibleRouletteWeb.PageLive do
  use Phoenix.LiveView

  alias D2CrucibleRoulette.Strats

  def render(assigns) do
    ~H"""
    <h1>Click the button to fetch a random strat!</h1>
    <button phx-click="fetch">Fetch</button>

    <%= if @strat do %>
      <h3><%= @strat.name %></h3>
      <p><%= @strat.description %></p>
      <span>
        Discord:
        <a href={"https://discordapp.com/users/#{@strat.author}"}><%= @strat.author %></a>
      </span>
      <div>
        <span>
          Likes: <%= @strat.likes %> - <button phx-click="like" phx-value-id={@strat.id}>Like</button>
        </span>
        <span>
          Dislikes: <%= @strat.dislikes %> - <button phx-click="dislike" phx-value-id={@strat.id}>Disike</button>
        </span>
      </div>
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

  def mount(_params, _session, socket) do
    socket = assign(socket, strat: nil, history: [])
    {:ok, socket}
  end

  def handle_event("fetch", _session, socket) do
    current_history = socket.assigns.history
    strat = Strats.random()
    history = [[strat.name, strat.description] | current_history]
    socket = assign(socket, strat: strat, history: history)

    {:noreply, socket}
  end

  def handle_event("like", %{"id" => strat_id}, socket) do
    with {:ok, strat} <- Strats.like(strat_id) do
      socket = assign(socket, strat: strat)
      {:noreply, socket}
    else
      _ ->
        {:noreply, socket}
    end
  end

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
