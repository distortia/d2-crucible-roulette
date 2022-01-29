defmodule D2CrucibleRouletteWeb.HistoryComponent do
  use D2CrucibleRouletteWeb, :live_component

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
