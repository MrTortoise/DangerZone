defmodule DangerZone.Game do
  alias __MODULE__

  @enforce_keys [:name, :players]
  defstruct [:name, :players]

  def new(name), do: %Game{name: name, players: %{}}
  def new(name, players), do: %Game{name: name, players: players}

  def add_player(game, player) do
    case Map.has_key?(game.players, player.name) do
      true -> {:error, :player_name_exists}
      false -> {:ok, new(game.name, Map.put(game.players, player.name, player))}
    end
  end
end
