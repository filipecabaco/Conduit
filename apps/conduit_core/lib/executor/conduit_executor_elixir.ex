defmodule ConduitCore.Executor.Elixir do
  use GenServer
  
  def start_link do
    IO.puts "Elixir Evaluator Starting"
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end
  
  def handle_call({:code, operations, input}, _from, _current) when is_list(operations) do
    composed = operations
    |> eval_operations
    |> Enum.map( fn({f,_}) -> f end )
    |> compose

    res = composed.(input)
    {:reply, res, :ok}
  end

  def handle_cast({:code, operations, input}, _current) do
    composed = operations
    |> eval_operations
    |> Enum.map( fn({f,_}) -> f end )
    |> compose

    spawn(fn()-> composed.(input) end)
    {:noreply, :ok}
  end

  def execute(operations, input, :sync) do
    GenServer.call(__MODULE__, {:code, operations, input})
  end
  
  def execute(operations, input, :async) do
    GenServer.cast(__MODULE__, {:code, operations, input})
  end

  defp eval_operations(operations) when is_list(operations), do: Enum.map(operations, &(Code.eval_string/1))
  defp eval_operations(operation), do: [Code.eval_string(operation)]

  defp compose(f, g), do: fn(x) -> f.(g.(x)) end
  defp compose(fs) when is_list(fs), do: List.foldl(fs, fn(x) -> x end, &compose/2)
end
