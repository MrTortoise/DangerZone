defmodule PlayDamageCardTest do
  use ExUnit.Case
  alias DangerZone.{Game, Player, Card}

  test "playing a damage card on a non undead player will heal them" do

    game = Game.new("steve", [])
    source = Player.new("dave")
    target = Player.new("dave2")

    game = Game.add_cards_to_deck(game, Card.harm(), 1)

    {:ok, game} = Game.add_player(game, source)
    {:ok, game} = Game.add_player(game, target)

    target_before = game.players[1]
    assert target_before.name == "dave2"
    assert target_before.health == 100

    {:ok, game} = Game.deal_card(game)
    card = game.players[0].cards[0]

    {:ok, game} = Game.play_card(game, 0, card.id, 1)

    source_after = game.players[0]
    assert Enum.count(source_after.cards) == 0

    target_after = game.players[1]
    assert target_after.health == 50
  end
end
