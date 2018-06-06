# defmodule EngineDealingTest do
#   use ExUnit.Case
#   alias DangerZone.{Player, Engine, Card}
#   doctest Engine

#   test "when dealing a card deck should lose card dealt and player should gain it" do
#     card = Card.new("card1", 10)
#     card2 = Card.new("card2", 12)

#     {deck, player} = Engine.deal_card([card, card2], Player.new("dave"))
#     assert deck == [card2]
#     assert [card] == player.cards
#   end
# end
