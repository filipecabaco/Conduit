defmodule ConduitCore.Supervisor.Elixir do
  use Supervisor
  import Logger

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(ConduitCore.Executor.Elixir, [], restart: :transient)
    ]
    res = supervise(children, strategy: :simple_one_for_one)
    info(inspect(res))
    res
  end

  def execute(operations, input) do
    {:ok, pid} = Supervisor.start_child(__MODULE__, [])
    result = GenServer.call(pid, {:code, operations, input})
    Supervisor.terminate_child(__MODULE__, pid)
    result
  end
end
