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

  def deal_action(number_of_players, deck_size), do: %{action: :deal, number_of_players: number_of_players, deck_size: deck_size}
  def play_card_action(player_index, number_of_players), do: %{action: :play_card, player_index: player_index, number_of_players: number_of_players}

  def check(%Rules{state: :pre_deal} = state, :add_player), do: {:ok, state}
  def check(%Rules{state: :pre_deal} = state, :add_card), do: {:ok, state}
  def check(%Rules{state: :pre_deal},
    %{action: :deal,
      number_of_players: number_of_players,
      deck_size: deck_size })
  when number_of_players * 10 <= deck_size and number_of_players > 1
    do
    {:ok, %Rules{state: {:player_turn, 0}}}
  end
  def check(%Rules{state: {:player_turn, current_index}}, %{action: :play_card, player_index: player_index, number_of_players:  number_of_players})
  when current_index == player_index do
    if current_index == number_of_players - 1 do
      {:ok, %Rules{state: {:player_turn, 0}}}
    else
      {:ok, %Rules{state: {:player_turn, current_index + 1}}}
    end
  end
  def check(%Rules{state: {:player_turn, _current_index}}, %{action: :win, player_index: player_index}) do
    {:ok, %Rules{state: {:win, player_index}}}
  end

  def check(_state, _action), do: :error

end
