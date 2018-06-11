defmodule DangerZone.Player do
  alias __MODULE__

  @enforce_keys [:name, :health, :is_undead, :cards]
  defstruct [:name, :health, :is_undead, :cards, :id]

  def new(name), do: new(name, false)

  def new(name, is_undead) do
    %Player{
      name: name,
      health: 100,
      is_undead: is_undead,
      cards: %{}
    }
  end

  def add_card(player, card) do
    cards = Map.put(player.cards, card.id, card)
    %Player{player | cards: cards}
  end

  def remove_card(player, card_id) do
    case Map.has_key?(player.cards, card_id) do
      true -> {:ok, %Player{player | cards:  Map.delete(player.cards, card_id)}}
      _ -> {:error, :card_not_found}
    end
  end

  def get_card(player, card_id) do
    case Map.has_key?(player.cards, card_id) do
      true -> {:ok, player.cards[card_id]}
      false -> {:error, :card_not_found}
    end
  end
end
