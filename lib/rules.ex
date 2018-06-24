defmodule DangerZone.Rules do
  alias __MODULE__

  @moduledoc """
  Rules is the state machine describing whether various actions are valid given current state
  IT also transitions between states

  States
  1. :pre_deal
  2. :playing
  3. :game_ended
  """

  defstruct state: :pre_deal

  def new(), do: %Rules{}

  def check(%Rules{state: :pre_deal} = state, :add_player), do: {:ok, state}
  def check(%Rules{state: :pre_deal} = state, :add_card), do: {:ok, state}
  def check(_state, _action), do: :error

end
