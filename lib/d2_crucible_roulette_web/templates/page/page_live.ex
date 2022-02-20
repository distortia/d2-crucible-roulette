defmodule D2CrucibleRouletteWeb.PageLive do
  use Phoenix.LiveView

  import ShorterMaps
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
        <.live_component module={StratComponent} id="strat-component" strat={@strat} like={@like} dislike={@dislike} admin?={@admin?} />
        <div class="hero is-dark">
          <div class="hero-body is-align-self-center">
            <button class="button is-primary is-medium" id="fetch-button" phx-click="fetch" phx-disable-with="Rolling...">
              <span class="icon rotate">
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
  def mount(_params, session, socket) do
    admin? = is_admin?(session)

    strat = Strats.random()
    history = []

    socket =
      assign(socket,
        strat: strat,
        history: history,
        like: "like",
        dislike: "dislike",
        admin?: admin?
      )

    {:ok, socket}
  end

  @doc """
  Fetch handles the `fetch` event when clicking the `roll` button
  Sends a new strat to be displayed and updates the history with the new strat

  Restore handles the `restore` event which restores session data containing the current strat and the strat history
  Sets the current strat id, history, like and dislike function to what is stored in the sessionStorage.
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
    Process.send(self(), {:save, strat.id, history, "like", "dislike"}, [])

    socket =
      assign(socket,
        strat: strat,
        history: history,
        like: "like",
        dislike: "dislike"
      )

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("restore", %{"currentStrat" => nil}, socket), do: {:noreply, socket}

  @impl Phoenix.LiveView
  def handle_event(
        "restore",
        %{
          "currentStrat" => strat_id,
          "currentHistory" => history,
          "currentLike" => like,
          "currentDislike" => dislike
        },
        socket
      ) do
    case Strats.get(strat_id) do
      nil ->
        {:noreply, socket}

      strat ->
        history = Jason.decode!(history)
        socket = assign(socket, ~M{strat, history, like, dislike})
        {:noreply, socket}
    end
  end

  @doc """
  Save takes the current strat and history and emits a JS event to save the items to sessionStorage

  Save recieves a message from the child strat compnent and sends itself a message to update the sessionStorage
  """
  @impl Phoenix.LiveView
  def handle_info({:save, strat_id, history, like, dislike}, socket) do
    history = Jason.encode!(history)

    {:noreply,
     push_event(socket, "setCurrent", %{
       strat: strat_id,
       history: history,
       like: like,
       dislike: dislike
     })}
  end

  def handle_info({:save, strat_id, like, dislike}, socket) do
    Process.send(
      self(),
      {:save, strat_id, socket.assigns.history, like, dislike},
      []
    )

    {:noreply, socket}
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

  defp is_admin?(session) do
    user_token = session["user_token"]

    cond do
      is_nil(user_token) ->
        false

      is_nil(D2CrucibleRoulette.Accounts.get_user_by_session_token(user_token)) ->
        false

      true ->
        case D2CrucibleRoulette.Accounts.get_user_by_session_token(user_token) do
          nil -> false
          user -> user.admin
        end
    end
  end
end
