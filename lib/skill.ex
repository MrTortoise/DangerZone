defmodule DangerZone.Skill do
  alias __MODULE__
  @enforce_keys [:name]

  defstruct [:name]

  def new(name), do: %Skill{name: name}
end
