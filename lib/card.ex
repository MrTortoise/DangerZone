defmodule DangerZone.Card do
  alias __MODULE__

  @enforce_keys [:name, :damage]
  defstruct [:name, :damage]

  def new(name, damage), do: %Card{name: name, damage: damage}

  def add_cards_to_deck(deck, _, 0), do: deck

  def add_cards_to_deck([] = deck, %Card{} = card, number),
    do: add_cards_to_deck([card | deck], card, number - 1)
end
