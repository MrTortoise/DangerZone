defmodule DangerZone.Engine do
  alias __MODULE__

  def deal_card(deck, player) do
    card = Enum.random(deck)
    new_deck = List.delete(deck, card)

    case Player.add_card(player, card) do
      {:ok, player_with_card} -> {:ok, new_deck, player_with_card}
      error                   -> error
    end
  end
end
