defmodule GameTest do
  use ExUnit.Case
  alias DangerZone.{Game, Player, Rules}
  doctest Game

  test "create game will have name" do
    game = Game.new("dave")
    assert game.name == "dave"
    assert Map.size(game.players) == 0
  end

  test "when add players to a game has player" do
    game = Game.new("dave", [])
    {:ok, game, _} = Game.add_player(game, Player.new("jim"))
    assert Map.size(game.players) == 1
    players = Map.values(game.players)
    assert Enum.any?(players, &(&1.name == "jim"))
  end

  test "get error when adding same player to game twice" do
    game = Game.new("dave", [])
    player = Player.new("jim")
    {:ok, game, _} = Game.add_player(game, player)
    assert {:error, :player_name_exists} = Game.add_player(game, player)
  end

  test "can update rules" do
    game = Game.new("steve")
    rules = %Rules{state: :dave}
    game = Game.update_rules(game, rules)
    assert game.rules.state == :dave
  end
end
