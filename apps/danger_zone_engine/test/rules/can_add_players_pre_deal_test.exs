defmodule RulesAddPlayerPreDealTest do
  use ExUnit.Case

  alias DangerZoneEngine.{Rules}

  test "game starts in pre-deal" do
    state = Rules.new()
    assert :pre_deal == state.state
  end

  test "can add player when in pre-deal" do
    {:ok, %Rules{state: state}} = Rules.check(Rules.new(), :add_player)
    assert state == :pre_deal
  end

  test "can add card when in pre_deal" do
    {:ok, %Rules{state: state}} = Rules.check(Rules.new(), :add_card)
    assert state == :pre_deal
  end
end
