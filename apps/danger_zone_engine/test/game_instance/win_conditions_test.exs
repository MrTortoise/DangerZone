defmodule WinConditionsTest do
  use ExUnit.Case
  alias DangerZoneEngine.{GameInstance}

  test "win when query player who's health is <= 0" do
    {:ok, game} = GameInstance.start_link("gameName")
    {:ok, player0} = GameInstance.add_player(game, "player0")
    {:ok, player1} = GameInstance.add_player(game, "player1")

    :ok = GameInstance.deal(game)

    player0cards = GameInstance.get_cards(game, player0)

    player0_harm_cards =
      Map.values(player0cards)
      |> Enum.filter(fn x -> x.name == "Harm" end)
      |> Enum.map(fn x -> x.id end)

    assert Enum.count(player0_harm_cards) >= 2

    player1cards = GameInstance.get_cards(game, player1)

    player1_heal_cards =
      Map.values(player1cards)
      |> Enum.filter(fn x -> x.name == "Heal" end)
      |> Enum.map(fn x -> x.id end)

    assert Enum.count(player1_heal_cards) >= 1

    player1_harm_cards =
      Map.values(player1cards)
      |> Enum.filter(fn x -> x.name == "Harm" end)
      |> Enum.map(fn x -> x.id end)

    assert Enum.count(player1_harm_cards) >= 1

    player0_query =
      Map.values(player0cards)
      |> Enum.filter(fn x -> x.name == "Query" end)
      |> Enum.map(fn x -> x.id end)

    assert Enum.count(player0_query) == 1

    _res = GameInstance.play_card(game, player0, Enum.at(player0_harm_cards, 0), player1)
    _res = GameInstance.play_card(game, player1, Enum.at(player1_heal_cards, 0), player0)

    _res = GameInstance.play_card(game, player0, Enum.at(player0_harm_cards, 1), player1)
    _res = GameInstance.play_card(game, player1, Enum.at(player1_harm_cards, 0), player0)

    res = GameInstance.play_card(game, player0, Enum.at(player0_query, 0), player1)

    assert res == {:winner, player0}
    assert true == true
  end
end
