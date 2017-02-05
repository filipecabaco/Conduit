defmodule ConduitCore.Supervisor do
  use Supervisor
  
  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(_) do
    IO.puts "Initiate children"
    children = [
      worker(ConduitCore.Executor.Elixir, [])
    ]
    IO.inspect children
    supervise(children, strategy: :one_for_one)
  end
end
