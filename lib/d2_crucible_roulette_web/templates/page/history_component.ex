defmodule D2CrucibleRouletteWeb.HistoryComponent do
  use D2CrucibleRouletteWeb, :live_component

  @moduledoc """
  The HistoryComponent is a basic display of a given strat.
  """

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div>
      <hr>
      <h2 class="has-text-light is-size-3">History</h2>
      <div class="is-flex is-flex-direction-column">
        <%= for [name, description] <- @history do %>
          <div class="card">
            <header class="card-header">
              <p class="card-header-title">
                <%= name %>
              </p>
            </header>
            <div class="card-content">
              <div class="content">
                <%= description %>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
