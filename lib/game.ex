defmodule DangerZone.Game do
  alias DangerZone.{Game, Player, Card}

  @enforce_keys [:name, :players, :deck, :to_act]
  defstruct [:name, :players, :deck, :to_act]

  def new(name, deck), do: new(name, deck, %{})
  def new(name, deck, players), do: %Game{name: name, players: players, deck: deck, to_act: 0}

  def add_player(%Game{} = game, %Player{} = player) do
    num = Enum.count(game.players)

    cond do
      num == 0 ->
        {:ok, %{game | players: Map.put(%{}, 0, player)}}

      true ->
        case Map.values(game.players)
             |> Enum.any?(&(&1.name == player.name)) do
          true ->
            {:error, :player_name_exists}

          false ->
            {:ok, %{game | players: Map.put(game.players, Enum.count(game.players), player)}}
        end
    end
  end

  def deal_card(%Game{} = game) do
    with {:ok, game} <- game_can_deal(game) do
      card = game.deck |> Enum.random()
      new_deck = game.deck |> List.delete(card)
      player = game.players[game.to_act] |> Player.add_card(card)
      players = Map.put(game.players, game.to_act, player)

      {:ok, %Game{game | deck: new_deck, players: players}}
    else
      err -> err
    end
  end

  def game_can_deal(%Game{} = game) do
    cond do
      game.deck == [] -> {:error, :empty_deck}
      Enum.count(game.players) == 0 -> {:error, :no_players}
      true -> {:ok, game}
    end
  end

  # def play_card(game_state, player_source, card, player_target) do
  #   with {:ok, player_source} <- Player.remove_card(player_source, card),
  #        {:ok, player_target} <- apply_card(player_target, card) do
  #       {:ok, player_source, player_target}
  #        else
  #         err -> err
  #     end
  # end
end
