defmodule D2CrucibleRoulette.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      D2CrucibleRoulette.Repo,
      # Start the Telemetry supervisor
      D2CrucibleRouletteWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: D2CrucibleRoulette.PubSub},
      # Start the Endpoint (http/https)
      D2CrucibleRouletteWeb.Endpoint,
      {Finch, name: Swoosh.Finch}
      # Start a worker by calling: D2CrucibleRoulette.Worker.start_link(arg)
      # {D2CrucibleRoulette.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: D2CrucibleRoulette.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    D2CrucibleRouletteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
