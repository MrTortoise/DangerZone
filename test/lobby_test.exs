defmodule LobbyTest do
  use ExUnit.Case
  alias DangerZone.{Lobby, Game}
  doctest Lobby

  test "on startup lobby will be empty" do
    {:ok, lobby} = Lobby.new()
    assert MapSet.size(lobby.games) == 0
  end

  test "After create game lobby will have game in it" do
    game_name = "dave"
    {:ok, lobby} = Lobby.new()
    game = Game.new(game_name, [])
    {:ok, lobby} = Lobby.add_game(lobby, game)
    assert MapSet.size(lobby.games) == 1
    assert game.name == game_name
  end
end
