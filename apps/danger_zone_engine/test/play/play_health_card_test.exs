defmodule PlayHealthCardTest do
  use ExUnit.Case
  alias DangerZoneEngine.{Game, Player, Card}

  test "playing a health card on a non undead player will heal them" do
    game = Game.new("steve", [])
    source = Player.new("dave")
    target = Player.new("dave2")

    game = Game.add_cards_to_deck(game, Card.heal(), 1)

    {:ok, game, player0} = Game.add_player(game, source)
    {:ok, game, player1} = Game.add_player(game, target)

    target_before = game.players[1]
    assert target_before.name == "dave2"
    assert target_before.health == 100

    {:ok, game} = Game.deal_card(game)
    card = game.players[player0].cards[0]

    {:ok, game, result} = Game.play_card(game, player0, card.id, player1)

    source_after = game.players[player0]
    assert Enum.count(source_after.cards) == 0

    target_after = game.players[player1]
    assert target_after.health == 150

    assert {:heal, 50} = result
  end
end
