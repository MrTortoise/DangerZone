defmodule DealingRulesTests do
  use ExUnit.Case

  alias DangerZone.{Rules}

  test "cannot deal if < 2 players" do
    result = Rules.check(Rules.new(), Rules.deal_action(1,20))
    assert result == :error
  end

  test "cannot deal if < 10 cars per player" do
    result = Rules.check(Rules.new(), Rules.deal_action(3,20))
    assert result == :error
  end

  def  add_2_players_and_20_cards() do
    {:ok, state} = Rules.check(Rules.new(), :add_player)
    {:ok, state} = Rules.check(state, :add_player)

    {:ok, state} = Rules.check(state, :add_card)

    state
  end

  test "can deal if more than 2 players and 20 cards" do
    state = add_2_players_and_20_cards()
    {:ok, state} = Rules.check(state, Rules.deal_action(2,20))

    assert %Rules{state: {:player_turn, 0}} = state
  end
end
