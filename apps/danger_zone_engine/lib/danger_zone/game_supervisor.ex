defmodule DangerZoneEngine.GameSupervisor do
  use Supervisor

  alias DangerZoneEngine.{GameInstance}

  def start_link(_options), do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok), do: Supervisor.init([GameInstance], strategy: :simple_one_for_one)

  def start_game(name), do: Supervisor.start_child(__MODULE__, [name])
  def stop_game(name), do: Supervisor.terminate_child(__MODULE__, GameInstance.pid_from_name(name))


end
