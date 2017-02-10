defmodule ConduitCore.Executor.Elixir do
  use GenServer
  import Logger

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end
  
  def handle_call({:code, operations, input}, from, _current) when is_list(operations) do
    info("#{inspect(from)} requested #{inspect(operations)} with the input #{inspect(input)}")
    composed = operations
    |> eval_operations
    |> Enum.map( fn({f,_}) -> f end )
    |> compose

    res = composed.(input)
    {:reply, res, :ok}
  end

  defp eval_operations(operations) when is_list(operations), do: Enum.map(operations, &(eval_operations(&1)))

  defp eval_operations(operation) do
    info("Evaluating elixir function: #{operation}")
    Code.eval_string(operation)
  end

  defp compose(f, g), do: fn(x) -> f.(g.(x)) end
  defp compose(fs) when is_list(fs), do: List.foldl(fs, fn(x) -> x end, &compose/2)
end
