defmodule WinningRulesTests do
  use ExUnit.Case

  alias DangerZone.{Rules}

  test "cannot win when pre_deal" do
    assert :error = Rules.check(Rules.new(), %{action: :win, player_index: 0})
  end

  test "can win when its a players turn" do
    state = %Rules{state: {:player_turn, 0}}
    {:ok, state} = Rules.check(state, %{action: :win, player_index: 0})
    assert state == %Rules{state: {:win, 0}}
  end
end
