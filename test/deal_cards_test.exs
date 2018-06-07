defmodule DealCardsTest do
  use ExUnit.Case
  alias DangerZone.{Game, Player, Card}

  test "when deal card player gets it, deck loses it, next to act is incremented" do
    card1 = Card.new("c1", 10)
    card2 = Card.new("c2", 20)
    game = Game.new("steve", [card1, card2])
    {:ok, game} = Game.add_player(game, Player.new("dave"))
    {:ok, game} = Game.add_player(game, Player.new("dave2"))

    {:ok, new_game} = Game.deal_card(game)
    assert Enum.count(new_game.deck) == 1
    assert new_game.to_act == 1

    {:ok, new_game} = Game.deal_card(new_game)
    assert Enum.count(new_game.deck) == 0
    assert new_game.to_act == 0

    assert Enum.count(new_game.players[0].cards) == 1
    assert Enum.count(new_game.players[1].cards) == 1
  end

  test "setup a deck of 20 cards, deal 5 to each player" do
    deck = Card.add_cards_to_deck([],Card.heal(), 10)
    deck = Card.add_cards_to_deck(deck,Card.hurt(), 10)

    game = Game.new("test",deck)
    game = Game.shuffle_deck(game)

    assert Enum.count(game.deck) == 20

    {:ok, game} = Game.add_player(game, Player.new("dave"))
    {:ok, game} = Game.add_player(game, Player.new("dave2"))

    game = Game.deal_cards(game, 5)
    assert Enum.count(game.deck) == 10
    assert Enum.count(game.players[0].cards) == 5
    assert Enum.count(game.players[1].cards) == 5
  end

end
