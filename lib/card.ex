defmodule DangerZone.Card do
  alias DangerZone.{Card, Player}

  @enforce_keys [:name, :value, :id, :type]
  defstruct [:name, :value, :id, :type]

  def new(name, value, type), do: %Card{id: -1, name: name, value: value, type: type}

  def heal(), do: new("Heal", 50, :heal)
  def harm(), do: new("Harm", 50, :harm)

  def apply(%Card{type: :heal} = card, %Player{} = target, %Player{} = source) do
    {
      card,
      %Player{target | health: target.health + card.value},
      source
    }
  end

  def apply(%Card{type: :harm} = card, %Player{} = target, %Player{} = source) do
    {
      card,
      %Player{target | health: target.health - card.value},
      source
    }
  end
end
