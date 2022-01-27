defmodule D2CrucibleRouletteWeb.StratComponent do
  use D2CrucibleRouletteWeb, :live_component

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div>
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
    </div>
    """
  end
end
