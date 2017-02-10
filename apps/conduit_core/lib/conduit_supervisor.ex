defmodule ConduitCore.Supervisor do
  use Supervisor
  import Logger

  def start_link(_type, _args) do
    res = Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    info(inspect(res))
    res
  end

  def init(_) do
    children = [
      supervisor(ConduitCore.Supervisor.Elixir, [])
    ]
    res = supervise(children, strategy: :one_for_one)
    info(inspect(res))
    res
  end
end
