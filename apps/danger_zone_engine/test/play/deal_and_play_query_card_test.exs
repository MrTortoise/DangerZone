defmodule QueryCardTest do
  use ExUnit.Case
  alias DangerZoneEngine.{Game, Player, Card}

  test "deal query to one player, get health of another" do
    game = Game.new("testGame")
    {game, _} = Game.add_player!(game, Player.new("dave"))
    {game, _} = Game.add_player!(game, Player.new("steve"))

    game =
      Game.add_cards_to_deck(game, Card.heal(), 3)
      |> Game.add_cards_to_deck(Card.query(), 1)

    {:ok, game} = Game.deal_card(game)
    {:ok, game} = Game.deal_card(game)

    {:ok, _, result} = Game.play_card(game, 0, 3, 1)

    assert {:query, 100} = result
  end
end
