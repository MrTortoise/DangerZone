defmodule PlayDamageCardTest do
  use ExUnit.Case
  alias DangerZone.{Game, Player, Card}

  test "playing a damage card on a non undead player will heal them" do
    game = Game.new("steve", [])
    source = Player.new("dave")
    target = Player.new("dave2")

    game = Game.add_cards_to_deck(game, Card.harm(), 1)

    {:ok, game, player0} = Game.add_player(game, source)
    {:ok, game, player1} = Game.add_player(game, target)

    target_before = game.players[player1]
    assert target_before.name == "dave2"
    assert target_before.health == 100

    {:ok, game} = Game.deal_card(game)
    card = game.players[player0].cards[0]

    {:ok, game, result} = Game.play_card(game, player0, card.id, player1)

    source_after = game.players[player0]
    assert Enum.count(source_after.cards) == 0

    target_after = game.players[player1]
    assert target_after.health == 50

    assert {:harm, 50} = result
  end

  test "when a player health drops below 0 then player is dead" do
    source = Player.new("dave")
    target = Player.new("dave2")
    card = Card.harm()

    %{target: target} = Player.apply_card(target, card, source)
    %{target: target} = Player.apply_card(target, card, source)
    %{target: target} = Player.apply_card(target, card, source)

    assert target.health < 0
    assert target.dead == true
  end
end
