defmodule ConduitCore do
  use Application
  def start(_type, _args) do
    ConduitCore.Supervisor.start_link
  end
end
