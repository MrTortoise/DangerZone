defmodule DangerZone.GameInstance do
  use GenServer

  alias DangerZone.{Game, Rules, Card}

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, [])
  end

  def init(name) do
    {:ok, Game.new(name)}
  end

  def add_player(game_instance, player) do
    GenServer.call(game_instance, {:add_player, player})
  end

  def deal(game_instance) do
    GenServer.call(game_instance, {:deal})
  end


  def handle_call({:add_player, player}, _from, game) do
    with {:ok, rules} <- Rules.check(game.rules, :add_player)
      do
        game
        |> Game.add_player!(player)
        |> Game.update_rules(rules)
        |> Game.add_cards_to_deck(Card.harm(), 9)
        |> Game.add_cards_to_deck(Card.heal(), 1)
        |> Game.add_cards_to_deck(Card.query(), 1)
        |> reply_success(:ok)
      else
        :error -> {:reply, :error, game}
      end
  end


  def handle_call({:deal}, _from, game) do
    with {:ok, rules} <- Rules.check(game.rules,
    %{action: :deal, number_of_players: Enum.count(game.players), deck_size: Enum.count(game.deck)} )
    do
      game
      |> Game.shuffle_deck()
      |> Game.deal_cards(5)
      |> Game.update_rules(rules)
      |> reply_success(:ok)
    else
      err -> {:reply, err, game}
    end
  end

  defp reply_success(game, reply) do
    {:reply, reply, game}
  end

end