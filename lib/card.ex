defmodule DangerZone.Card do
  alias DangerZone.{Card, Player}

  @enforce_keys [:name, :damage, :id]
  defstruct [:name, :damage, :id]

  def new(name, damage), do: %Card{id: -1,name: name, damage: damage}

  def heal(), do: new("Heal", -50)
  def hurt(), do: new("Hurt", 50)

  def apply(%Card{} = card, %Player{} =  target, %Player{} =  source) do
    {
      card,
      %Player{target | health: target.health + card.damage},
      source
    }
  end
end
