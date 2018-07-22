defmodule DangerZone.Card do
  alias DangerZone.{Card}

  @enforce_keys [:name, :value, :id, :type]
  defstruct [:name, :value, :id, :type]

  def new(name, value, type), do: %Card{id: -1, name: name, value: value, type: type}

  def heal(), do: new("Heal", 50, :heal)
  def harm(), do: new("Harm", 50, :harm)
  def query(), do: new("Query", 0, :query)
end
