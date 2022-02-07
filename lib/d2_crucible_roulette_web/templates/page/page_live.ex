defmodule D2CrucibleRouletteWeb.PageLive do
  use Phoenix.LiveView

  alias D2CrucibleRoulette.Strats
  alias D2CrucibleRouletteWeb.{HistoryComponent, StratComponent}

  @moduledoc """
  PageLive is the main page for the application where users can get a random strat and view their strat history within their session.
  """

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="section">
      <div class="container" id="page-live" phx-hook="Restore">
        <.live_component module={StratComponent} id="strat-component" strat={@strat}/>
        <div class="hero is-dark">
          <div class="hero-body is-align-self-center">
            <button class="button is-primary is-medium" id="fetch-button" phx-click="fetch" phx-disable-with="Rolling...">
              <span class="icon">
                <i class="fas fa-dice-d20"></i>
              </span>
              <span>Roll</span>
            </button>
          </div>
        </div>
        <.live_component module={HistoryComponent} id="history-component" history={@history} />
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    strat = Strats.random()
    history = []
    socket = assign(socket, strat: strat, history: history)
    {:ok, socket}
  end

  @doc """
  Fetch handles the `fetch` event when clicking the `roll` button
  Sends a new strat to be displayed and updates the history with the new strat

  Like handles the `like` event when clicking the thumbs-up on the given strat
  Sends an update to the component that initiated the event or returns
  nothing if something failed

  Dislike handles the `dislike` event when clicking the thumbs-down on the given strat
  Sends an update to the component that initiated the event or returns
  nothing if something failed


  Restore handles the `restore` event which restores session data containing the current strat and the strat history
  Sets the current strat and history to what is stored in the sessionStorage.
  If currentStrat is nil, then we continue on as normal
  """
  @impl Phoenix.LiveView
  def handle_event("fetch", _session, socket) do
    current_history = socket.assigns.history
    previous_strat = socket.assigns.strat

    strat =
      Strats.random()
      |> refetch_if_dupe(current_history)

    history = push_history(previous_strat, current_history)
    Process.send(self(), {:save, strat.id, history}, [])
    socket = assign(socket, strat: strat, history: history)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("like", %{"id" => strat_id}, socket) do
    case Strats.like(strat_id) do
      {:ok, strat} ->
        Process.send(self(), {:save, strat_id, socket.assigns.history}, [])
        socket = assign(socket, strat: strat)
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("dislike", %{"id" => strat_id}, socket) do
    case Strats.dislike(strat_id) do
      {:ok, strat} ->
        Process.send(self(), {:save, strat_id, socket.assigns.history}, [])
        socket = assign(socket, strat: strat)
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("restore", %{"currentStrat" => nil}, socket), do: {:noreply, socket}

  @impl Phoenix.LiveView
  def handle_event("restore", %{"currentStrat" => strat_id, "currentHistory" => history}, socket) do
    case Strats.get(strat_id) do
      nil ->
        {:noreply, socket}

      strat ->
        history = Jason.decode!(history)
        socket = assign(socket, strat: strat, history: history)
        {:noreply, socket}
    end
  end

  @doc """
  Save takes the current strat and history and emits a JS event to save the items to sessionStorage
  """
  @impl Phoenix.LiveView
  def handle_info({:save, strat_id, history}, socket) do
    history = Jason.encode!(history)
    {:noreply, push_event(socket, "setCurrent", %{strat: strat_id, history: history})}
  end

  defp refetch_if_dupe(strat, []), do: strat

  defp refetch_if_dupe(strat, history) do
    case Enum.member?(history, [strat.name, strat.description]) do
      true ->
        Strats.random()
        |> refetch_if_dupe(history)

      false ->
        strat
    end
  end

  defp push_history(strat, history) do
    [[strat.name, strat.description] | history]
  end
end
