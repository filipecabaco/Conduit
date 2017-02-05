defmodule ConduitCore.Evaluator.Elixir do
  use GenServer

  def start_link do
    IO.puts "Elixir Evaluator Starting"
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end
  
  def handle_call({:code, content}, _from, _input) do
    {:reply, content, []}
  end

  def handle_cast({:code, _content}, _input) do
    {:no_reply, []}
  end

  def execute_sync(code), do: GenServer.call(__MODULE__, {:code, code})
  
  def execute_async(code), do: GenServer.cast(__MODULE__, {:code, code})

end
