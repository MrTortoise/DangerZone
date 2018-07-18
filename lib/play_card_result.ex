defmodule DangerZone.PlayCardResult do
  alias __MODULE__

  @enforce_keys []
  defstruct [:winner, :value, :id, :type]
end
