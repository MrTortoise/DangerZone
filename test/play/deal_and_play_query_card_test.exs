defmodule QueryCardTest do
  use ExUnit.Case
  alias DangerZone.{Game, Player, Card}

  test "deal query to one player, get health of another" do
    game =
      Game.new("testGame")
      |> Game.add_player!(Player.new("dave"))
      |> Game.add_player!(Player.new("steve"))
      |> Game.add_cards_to_deck(Card.heal(), 3)
      |> Game.add_cards_to_deck(Card.query(), 1)


      {:ok, game} = Game.deal_card(game)
      {:ok, game} = Game.deal_card(game)

      IO.inspect game

      {:ok, game, result} = Game.play_card(game, 0, 3, 1)

      assert {:query, 100} = result
  end
end
