defmodule DangerZone.GameSupervisor do
  use Supervisor

  alias DangerZone.GameInstance


  def start_link(_options), do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__ )

  def init(:ok), do: Supervisor.init([GameInstance], strategy: :simple_one_for_one)
end