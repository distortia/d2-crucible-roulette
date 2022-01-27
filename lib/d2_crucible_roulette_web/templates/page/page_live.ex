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
    strat = D2CrucibleRoulette.Strats.random()
    history = [[strat.name, strat.description] | current_history]
    socket = assign(socket, strat: strat, history: history)

    {:noreply, socket}
  end
end
