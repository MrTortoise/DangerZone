defmodule DangerZone.Game do
  alias DangerZone.{Game, Player}

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
      card =
        game.deck
        |> Enum.random()

      new_deck =
        game.deck
        |> List.delete(card)

      player =
        game.players[game.to_act]
        |> Player.add_card(card)

      players = Map.put(game.players, game.to_act, player)

      {:ok, %Game{game | deck: new_deck, players: players, to_act: increment_to_act(game)}}
    else
      err -> err
    end
  end

  defp increment_to_act(%Game{} = game) do
    num = Enum.count(game.players)

    cond do
      num - 1 == game.to_act -> 0
      true -> game.to_act + 1
    end
  end

  def game_can_deal(%Game{} = game) do
    cond do
      game.deck == [] -> {:error, :empty_deck}
      Enum.count(game.players) == 0 -> {:error, :no_players}
      true -> {:ok, game}
    end
  end

  def shuffle_deck(%Game{} = game) do
    %Game{game | deck: game.deck |> Enum.shuffle}
  end
end
