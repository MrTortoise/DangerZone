defmodule DangerZone.Game do
  alias DangerZone.{Game, Player, Card}

  @enforce_keys [:name, :players, :deck, :to_act, :spent]
  defstruct [:name, :players, :deck, :to_act, :spent]

  def new(name), do: new(name, %{})
  def new(name, players), do: %Game{
    name: name,
    players: players,
    deck: [],
    to_act: 0,
    spent: []}

  def get_player(%Game{} = game, player_id) do
    Map.fetch(game.players, player_id)
  end

  def get_card(%Game{} = game, card_id) do
    result = Enum.find(game.deck, :not_found, fn (x) -> x.id == card_id end)
    case result do
      :not_found -> {:error, :not_found}
      card -> {:ok, card}
    end
  end

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

  def add_cards_to_deck(%Game{} = game, _, 0), do: game

  def add_cards_to_deck(%Game{} = game, %Card{} = card, number) do
    id = Enum.count(game.deck)
    card = %Card{card | id: id}
    game = %Game{game | deck: [card | game.deck]}
    add_cards_to_deck(game, card, number - 1)
  end


  def play_card(%Game{} = game, source_player_id, card_id, target_player_id) do
    with {:ok, source_player} <- get_player(game, source_player_id),
         {:ok, card} <- Player.get_card(source_player, card_id),
         {:ok, target_player} <- get_player(game, target_player_id) do

      {:ok, source_no_card} = Player.remove_card(source_player, card_id)
      {card, target_player, source_no_card} = Card.apply(card, target_player, source_no_card)
      players = game.players
        |> Map.put(source_no_card.id, source_no_card)
        |> Map.put(target_player.id, target_player)

      %Game{game | players: players, spent: [card | game.spent]}
    else
      err -> err
    end
  end

  def deal_cards(%Game{} = game, number) do
    total_cards = number * Enum.count(game.players)
    deal_cards_loop(game, total_cards)
  end

  defp deal_cards_loop(%Game{} = game, 0), do: game
  defp deal_cards_loop(%Game{} = game, remaining) do
    {:ok, game} = deal_card(game)
    deal_cards_loop(game, remaining-1)
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
