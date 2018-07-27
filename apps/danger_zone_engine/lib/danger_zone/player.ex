defmodule DangerZoneEngine.Player do
  alias DangerZoneEngine.{Player, Card}

  @enforce_keys [:name, :health, :is_undead, :cards, :dead]
  defstruct [:name, :health, :is_undead, :cards, :id, :dead]

  def new(name), do: new(name, false)

  def new(name, is_undead) do
    %Player{
      name: name,
      health: 100,
      is_undead: is_undead,
      cards: %{},
      dead: false
    }
  end

  def add_card(player, card) do
    cards = Map.put(player.cards, card.id, card)
    %Player{player | cards: cards}
  end

  def remove_card(player, card_id) do
    case Map.has_key?(player.cards, card_id) do
      true -> {:ok, %Player{player | cards: Map.delete(player.cards, card_id)}}
      _ -> {:error, :card_not_found_on_player}
    end
  end

  def get_card(player, card_id) do
    case Map.has_key?(player.cards, card_id) do
      true -> {:ok, player.cards[card_id]}
      false -> {:error, :card_not_found_on_player}
    end
  end

  def apply_card(%Player{} = target, %Card{type: :heal} = card, %Player{} = source) do
    %{
      target: %Player{target | health: target.health + card.value},
      source: source,
      result: {:heal, card.value}
    }
  end

  def apply_card(%Player{} = target, %Card{type: :harm} = card, %Player{} = source) do
    new_health = target.health - card.value

    %{
      target: apply_health_to_player(target, new_health),
      source: source,
      result: {:harm, card.value}
    }
  end

  defp apply_health_to_player(%Player{is_undead: false} = target, new_health)
       when new_health <= 0 do
    %Player{target | health: new_health, dead: true}
  end

  defp apply_health_to_player(%Player{is_undead: true} = target, new_health)
       when new_health >= 0 do
    %Player{target | health: new_health, dead: true}
  end

  defp apply_health_to_player(%Player{} = target, new_health) do
    %Player{target | health: new_health}
  end
end
