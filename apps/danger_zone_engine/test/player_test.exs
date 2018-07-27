defmodule PlayerTest do
  use ExUnit.Case
  alias DangerZoneEngine.{Player, Card}
  doctest Player

  test "when create undead player undead is set, health is 100 and name is right" do
    name = "dave"
    player = Player.new(name, true)
    assert name == player.name
    assert true == player.is_undead
    assert 100 == player.health
  end

  test "when create number player undead is false, health is 100 and name is right" do
    name = "jimbo"
    player = Player.new(name, false)
    assert name == player.name
    assert false == player.is_undead
    assert 100 == player.health
  end

  test "when add a card to player cards has 1 in it" do
    player = Player.new("dave")
    card1 = Card.new("card1", 10, :heal) |> Map.put(:id, 0)
    card2 = Card.new("card2", 13, :harm) |> Map.put(:id, 1)
    assert %{} = player.cards
    pwc = Player.add_card(player, card1)
    assert card1 == pwc.cards[card1.id]

    pwc2 = Player.add_card(pwc, card2)
    assert Enum.count(pwc2.cards) == 2
    assert card2 == pwc2.cards[card2.id]
  end
end
