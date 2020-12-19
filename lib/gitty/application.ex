defmodule Gitty.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  # import Supervisor.Spec
  alias Gitty.DocumentRegistry
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Gitty.Repo,
      # Start the Telemetry supervisor
      GittyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Gitty.PubSub},
      # Start the Endpoint (http/https)
      GittyWeb.Endpoint,
      GittyWeb.Presence,
      # Start a worker by calling: Gitty.Worker.start_link(arg)
      # {Gitty.Worker, arg}
      # {GittyWeb., [pool_size: :erlang.system_info(:schedulers_online)]},
      Gitty.DocumentRegistry
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gitty.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GittyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
