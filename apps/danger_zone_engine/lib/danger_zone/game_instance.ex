defmodule DangerZoneEngine.GameInstance do
  use GenServer, start: {__MODULE__, :start_link, []}, restart: :transient

  alias DangerZoneEngine.{Game, Rules, Card, Player}

  @timeout 60 * 60 * 24 * 1000

  def via_tuple(name), do: {:via, Registry, {Registry.DangerZoneEngine, name}}

  def pid_from_name(name) do
    name
    |> via_tuple()
    |> GenServer.whereis()
  end

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def init(name) do
    send(self(), {:set_state, name})
    {:ok, Game.new(name), @timeout}
  end

  def add_player(game_instance, player_name) do
    GenServer.call(game_instance, {:add_player, player_name})
  end

  def deal(game_instance) do
    GenServer.call(game_instance, {:deal})
  end

  def get_cards(game_instance, player_id) do
    GenServer.call(game_instance, {:get_cards, player_id})
  end

  def play_card(game_instance, source_player_id, card_id, target_player_id) do
    GenServer.call(game_instance, {:play_card, source_player_id, card_id, target_player_id})
  end

  def stop_game(name) do
    :ets.delete(:game_state, name)
    Supervisor.terminate_child(__MODULE__, pid_from_name(name))
  end

  def terminate({:shutdown, :timeout}, state_data) do
    :ets.delete(:game_state, state_data.name)
    :ok
  end
  def terminate(_reason, _state), do: :ok

  def handle_info(:timeout, state) do
    {:stop, {:shutdown, :timeout}, state}
  end

  def handle_info({:set_state, name}, _state_data) do
    state_data =
    case :ets.lookup(:game_state, name) do
      [] -> Game.new(name)
      [{_key, state}] -> state
    end
    :ets.insert(:game_state, {name, state_data})
    {:noreply, state_data, @timeout}
  end

  def handle_call({:add_player, player_name}, _from, game) do
    with player <- Player.new(player_name),
         {:ok, rules} <- Rules.check(game.rules, :add_player),
         {:ok, game, player_id} <- Game.add_player(game, player) do
      game
      |> Game.update_rules(rules)
      |> Game.add_cards_to_deck(Card.harm(), 8)
      |> Game.add_cards_to_deck(Card.heal(), 2)
      |> reply_success({:ok, player_id})
    else
      err -> reply_error(game, err)
    end
  end

  def handle_call({:deal}, _from, game) do
    with {:ok, rules} <-
           Rules.check(
             game.rules,
             %{
               action: :deal,
               number_of_players: Enum.count(game.players),
               deck_size: Enum.count(game.deck)
             }
           ) do
      game
      |> Game.add_cards_to_deck(Card.query(), 1)
      |> Game.deal_cards(1)
      |> Game.shuffle_deck()
      |> Game.deal_cards(5)
      |> Game.update_rules(rules)
      |> reply_success(:ok)
    else
      err -> reply_error(game, err)
    end
  end

  def handle_call({:get_cards, player}, _from, game) do
    reply_success(game, game.players[player].cards)
  end

  def handle_call({:play_card, source_player, card_id, target_player}, _from, game) do
    number_players = Enum.count(game.players)

    with {:ok, rules} <-
           Rules.check(game.rules, %{
             action: :play_card,
             player_index: source_player,
             number_of_players: number_players
           }),
         {:ok, player} <- Game.get_player(game, source_player),
         {:ok, card} <- Player.get_card(player, card_id),
         {:ok, game, result} <- Game.play_card(game, source_player, card_id, target_player) do
      game
      |> Game.update_rules(rules)
      |> reply_play_card_result(result, card)
    else
      err -> reply_error(game, err)
    end
  end

  defp reply_play_card_result(
         %Game{} = game,
         {:query, 0} = result,
         %Card{name: "Query"}
       ) do
    players = Map.values(game.players)
    surviving_players = Enum.filter(players, fn p -> p.dead == false end)

    case Enum.count(surviving_players) == 1 do
      true -> reply_success(game, {:winner, Enum.at(surviving_players, 0).id})
      false -> reply_success(game, result)
    end
  end

  defp reply_play_card_result(%Game{} = game, result, _) do
    reply_success(game, result)
  end

  defp reply_success(game, result) do
    :ets.insert(:game_state, {game.name, game})
    {:reply, result, game, @timeout}
  end

  defp reply_error(game, error) do
    {:reply, error, game, @timeout}
  end

  # defp build_id() do
  #   Integer.to_string(:rand.uniform(4294967296), 32) <> Integer.to_string(:rand.uniform(4294967296), 32)
  # end
end
