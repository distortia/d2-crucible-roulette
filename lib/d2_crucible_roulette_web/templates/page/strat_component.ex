defmodule D2CrucibleRouletteWeb.StratComponent do
  use D2CrucibleRouletteWeb, :live_component

  @moduledoc """
  A StratComponent is a basic representation of a given strat which displays all of the strat's information
  """

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="card" id={"strat-#{@strat.id}"} phx-hook="setCurrent" >
      <header class="card-header">
        <p class="card-header-title strat-name">
          <%= @strat.name %>
        </p>
      </header>
      <div class="card-content">
        <div class="content">
          <%= @strat.description %>
          <div class="subtitle">
            - <a href={"https://discordapp.com/users/#{@strat.author}"}><%= @strat.author %></a>
          </div>
        </div>
      </div>
      <footer class="card-footer">
        <a class="card-footer-item has-text-success" phx-click="like" phx-value-id={@strat.id}>
          <span class="icon-text">
            <span class="icon">
              <i class="fas fa-thumbs-up"></i>
            </span>
            <span class="strat-likes"><%= @strat.likes %></span>
          </span>
        </a>
        <a class="card-footer-item has-text-danger" phx-click="dislike" phx-value-id={@strat.id}>
          <span class="icon-text">
            <span class="icon">
              <i class="fas fa-thumbs-down"></i>
            </span>
            <span class="strat-dislikes"><%= @strat.dislikes %></span>
          </span>
        </a>
      </footer>
    </div>
    """
  end
end
