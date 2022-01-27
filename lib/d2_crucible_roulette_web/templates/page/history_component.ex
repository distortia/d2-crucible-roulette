defmodule D2CrucibleRouletteWeb.HistoryComponent do
  use D2CrucibleRouletteWeb, :live_component

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div>
      <%= for [name, description] <- @history do %>
        <div>
          <h4>
            <%= name %>
          </h4>
          <p><%= description %></p>
        </div>
      <% end %>
    </div>
    """
  end
end
