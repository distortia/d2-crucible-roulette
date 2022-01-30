defmodule D2CrucibleRouletteWeb.StratComponent do
  use D2CrucibleRouletteWeb, :live_component

  @moduledoc """
  A StratComponent is a basic representation of a given strat which displays all of the strat's information
  """

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="card">
      <header class="card-header">
        <p class="card-header-title">
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
        <div class="card-footer-item">
          <span class="icon-text has-text-success">
            <span class="icon" phx-click="like" phx-value-id={@strat.id}>
              <i class="fas fa-thumbs-up"></i>
            </span>
            <span><%= @strat.likes %></span>
          </span>
        </div>
        <div class="card-footer-item">
          <span class="icon-text has-text-danger">
            <span class="icon" phx-click="dislike" phx-value-id={@strat.id}>
              <i class="fas fa-thumbs-down"></i>
            </span>
            <span><%= @strat.dislikes %></span>
          </span>
        </div>
      </footer>
    </div>
    """
  end
end
