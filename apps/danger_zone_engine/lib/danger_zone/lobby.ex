defmodule DangerZoneEngine.Lobby do
  alias __MODULE__

  @enforce_keys [:games]
  defstruct [:games]

  def new(), do: {:ok, %Lobby{games: MapSet.new()}}
  def new(games), do: {:ok, %Lobby{games: games}}

  def add_game(lobby, game) do
    new(MapSet.put(lobby.games, game))
  end
end
