defmodule ConduitCore.Supervisor do
  use Supervisor

  def start_link(_type, _args) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    |> IO.inspect
  end

  def init(_) do
    children = [
      supervisor(ConduitCore.Supervisor.Elixir, [])
    ]
    supervise(children, strategy: :one_for_one)
    |> IO.inspect
  end
end
