defmodule ConduitCore.Executor.Elixir do
  import Helpers.Compose
  use GenServer
  
  def start_link do
    IO.puts "Elixir Evaluator Starting"
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end
  
  def handle_call({:code, operations, input}, _from, _current) when is_list(operations) do
    res = multicompose(operations).(input)
    {:reply, res, []}
  end

  def handle_cast({:code, operations, input}, _current) do
     multicompose(operations).(input)
    {:noreply, :ok}
  end

  def execute_sync(operations, input) do
    GenServer.call(__MODULE__, {:code, operations, input})
  end
  
  def execute_async(operations, input) do
    GenServer.cast(__MODULE__, {:code, operations, input})
  end

end
