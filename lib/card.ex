defmodule DangerZone.Card do
  alias __MODULE__

  @enforce_keys [:name, :damage]
  defstruct [:name, :damage]

  def new(name, damage), do: %Card{name: name, damage: damage}
end
