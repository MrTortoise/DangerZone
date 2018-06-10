defmodule PlayHealthCardTest do
  use ExUnit.Case
  alias DangerZone.{Game, Player, Card}

  test "playing a health card on a non undead player will heal them" do

    heal_card = Card.new("c1", 50)

    game = Game.new("steve", [])
    source = Player.new("dave")
    target = Player.new("dave2")

    {:ok, game} = Game.add_cards_to_deck(game, heal_card, 1)

    {:ok, game} = Game.add_player(game, source)
    {:ok, game} = Game.add_player(game, target)

    target_before = game.players[0]
    assert target_before.health == 100

    {:ok,  game} = Game.play_card(game, source, heal_card, target)

    source_after = game.players[0]
    assert Enum.count(source_after.cards) == 0

    target_after = game.players[1]
    assert target_after.health == 150

  end

end
