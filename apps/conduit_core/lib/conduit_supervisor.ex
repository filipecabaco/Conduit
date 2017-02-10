defmodule ConduitCore.Supervisor do
  use Supervisor

  def start_link(_type, _args) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    |> IO.inspect
  end

  def init(_) do
    children = [
      worker(ConduitCore.Executor.Elixir, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
    |> IO.inspect
  end

  def execute(operations, input, :elixir) do
    {:ok, pid} = Supervisor.start_child(ConduitCore.Supervisor, [])
    result = GenServer.call(pid, {:code, operations, input})
    Supervisor.terminate_child(ConduitCore.Supervisor, pid)
    result
  end
end
