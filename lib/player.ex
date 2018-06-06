defmodule DangerZone.Player do
  alias __MODULE__

  @enforce_keys [:name, :health, :is_undead, :cards]
  defstruct [:name, :health, :is_undead, :cards]

  def new(name), do: new(name, false)

  def new(name, is_undead) do
    %Player{
      name: name,
      health: 100,
      is_undead: is_undead,
      cards: []
    }
  end

  def add_card(player, card) do
    cards = player.cards ++ [card]
    Map.put(player, :cards, cards)
  end
end
