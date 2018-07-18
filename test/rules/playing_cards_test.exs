defmodule PlayingCardsRulesTests do
  use ExUnit.Case

  alias DangerZone.{Rules}

  test "cannot play cards when pre_deal" do
    result = Rules.check(Rules.new(), Rules.play_card_action(0, 2))
    assert result == :error
  end

  test "play card -> current player index increases" do
    state = %Rules{state: {:player_turn, 0}}

    {:ok, %Rules{state: {:player_turn, current_index}}} =
      Rules.check(state, Rules.play_card_action(0, 2))

    assert current_index == 1
  end

  test "las player plays card -> current player index becomes 0" do
    state = %Rules{state: {:player_turn, 1}}

    {:ok, %Rules{state: {:player_turn, current_index}}} =
      Rules.check(state, Rules.play_card_action(1, 2))

    assert current_index == 0
  end

  test "error if player plays out of turn" do
    state = %Rules{state: {:player_turn, 0}}
    assert Rules.check(state, Rules.play_card_action(1, 2)) == :error
  end
end
