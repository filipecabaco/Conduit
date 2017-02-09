defmodule ConduitCore do
  use Application
  def start(type, args) do
    ConduitCore.Supervisor.start_link(type, args)
  end
end
