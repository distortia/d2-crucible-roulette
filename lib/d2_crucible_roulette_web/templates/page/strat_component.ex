defmodule D2CrucibleRouletteWeb.StratComponent do
  use D2CrucibleRouletteWeb, :live_component
  alias D2CrucibleRoulette.Strats

  @moduledoc """
  A StratComponent is a basic representation of a given strat which displays all of the strat's information
  """

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="card" id={"strat-#{@strat.id}"} phx-hook="setCurrent" >
      <header class="card-header">
        <p class="card-header-title strat-name"><%= @strat.name %></p>
        <%= if @admin? do %>
          <%= link "Edit", to: Routes.strat_path(@socket, :edit, @strat.id), class: "button is-warning mr-1 mt-1" %>
        <% end %>
      </header>
      <div class="card-content">
        <div class="content">
          <div class="description"><%= @strat.description %></div>
          <div class="subtitle">
            - <a href={"https://discordapp.com/users/#{@strat.author}"}><%= @strat.author %></a>
          </div>
        </div>
      </div>
      <footer class="card-footer">
        <a class="card-footer-item has-text-success like-button" phx-click={@like} phx-value-id={@strat.id} phx-target={@myself}>
          <span class="icon-text">
            <span class="icon">
              <i class="fas fa-thumbs-up"></i>
            </span>
            <span class="strat-likes"><%= @strat.likes %></span>
          </span>
        </a>
        <a class="card-footer-item has-text-danger dislike-button" phx-click={@dislike} phx-value-id={@strat.id} phx-target={@myself}>
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

  @doc """
  Like handles the `like` event when clicking the thumbs-up on the given strat
  Sends an update to the component that initiated the event or returns
  nothing if something failed

  Unlike handles the `unlike` event which will "undo" the liked strat

  Dislike handles the `dislike` event when clicking the thumbs-down on the given strat
  Sends an update to the component that initiated the event or returns
  nothing if something failed

  Undislike handles the `undislike` event which will "undo" disliking a strat
  """
  @impl Phoenix.LiveComponent
  def handle_event("like", %{"id" => strat_id}, socket) do
    case Strats.like(strat_id) do
      {:ok, strat} ->
        update_parent(strat_id, "unlike", socket.assigns.dislike)

        socket = assign(socket, strat: strat, like: "unlike")
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  @impl Phoenix.LiveComponent
  def handle_event("unlike", %{"id" => strat_id}, socket) do
    case Strats.unlike(strat_id) do
      {:ok, strat} ->
        update_parent(strat_id, "like", socket.assigns.dislike)

        socket = assign(socket, strat: strat, like: "like")
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  @impl Phoenix.LiveComponent
  def handle_event("dislike", %{"id" => strat_id}, socket) do
    case Strats.dislike(strat_id) do
      {:ok, strat} ->
        update_parent(strat_id, socket.assigns.like, "undislike")

        socket = assign(socket, strat: strat, dislike: "undislike")
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  @impl Phoenix.LiveComponent
  def handle_event("undislike", %{"id" => strat_id}, socket) do
    case Strats.undislike(strat_id) do
      {:ok, strat} ->
        update_parent(strat_id, socket.assigns.like, "dislike")

        socket = assign(socket, strat: strat, dislike: "dislike")
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  defp update_parent(strat_id, like, dislike) do
    Process.send(
      self(),
      {:save, strat_id, like, dislike},
      []
    )
  end
end
