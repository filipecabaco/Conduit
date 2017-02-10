defmodule ConduitCore.Supervisor.Elixir do
  use Supervisor

  def start_link do
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

  def execute(operations, input) do
    {:ok, pid} = Supervisor.start_child(__MODULE__, [])
    result = GenServer.call(pid, {:code, operations, input})
    Supervisor.terminate_child(__MODULE__, pid)
    result
  end
end
