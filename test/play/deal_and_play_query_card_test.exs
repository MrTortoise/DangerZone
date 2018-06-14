defmodule QueryCardTest do
  use ExUnit.Case
  alias DangerZone.{Game, Player, Card}

  test "deal query to one player, get health of another" do
    game = Game.new("testGame")
    |> Game.add_player!(Player.new("dave"))
    |> Game.add_player!(Player.new("steve"))

    assert Enum.count(game.players) == 2
  end

end
