defmodule GameTest do
  use ExUnit.Case
  alias DangerZone.{Game, Player, Card}
  doctest Game

  test "create game will have name" do
    with %Card{} = card <- Card.new("c1", 100) do
      game = Game.new("dave", [card])
      assert game.name == "dave"
      assert Map.size(game.players) == 0
      assert game.deck == [card]
    end
  end

  test "when add players to a game has player" do
    game = Game.new("dave", [])
    {:ok, game} = Game.add_player(game, Player.new("jim"))
    assert Map.size(game.players) == 1
    players = Map.values(game.players)
    assert Enum.any?(players, &(&1.name == "jim"))
  end

  test "get error when adding same player to game twice" do
    game = Game.new("dave", [])
    player = Player.new("jim")
    {:ok, game} = Game.add_player(game, player)
    assert {:error, :player_name_exists} = Game.add_player(game, player)
  end


end
