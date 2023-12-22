defmodule Moltres.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MoltresWeb.Telemetry,
      Moltres.Repo,
      {DNSCluster, query: Application.get_env(:moltres, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Moltres.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Moltres.Finch},
      # Start a worker by calling: Moltres.Worker.start_link(arg)
      # {Moltres.Worker, arg},
      # Start to serve requests, typically the last entry
      MoltresWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Moltres.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MoltresWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
