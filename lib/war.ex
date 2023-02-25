defmodule War do
  @doc """
  The main module to the challenge.
  This module exposes a deal/1 function to play the game.

  You can run all tests executing `elixir war.ex`.
  """
  require Integer

  # prefers to use a weight as we don't represent the cards
  @ace_weight 14

  def deal(deck) do
    {deck_1, deck_2} = deal_deck(deck)

    {:ok, player_1} = Queue.start_link()
    {:ok, player_2} = Queue.start_link()

    :ok = Queue.enqueue(player_1, deck_1)
    :ok = Queue.enqueue(player_2, deck_2)

    winner = play_game(player_1, player_2)

    Queue.size(winner)
    |> then(&Queue.dequeue(winner, &1))
    |> Enum.map(&remove_ace_weight/1)
  end

  defp deal_deck(deck) do
    List.foldr(deck, {[], []}, &deal_player/2)
  end

  defp play_game(p1, p2) do
    if winner = maybe_get_winner(p1, p2) do
      winner
    else
      case play_turn(p1, p2) do
        {winner, []} ->
          winner

        {turn_winner, cards} ->
          push_cards(turn_winner, cards)
          play_game(p1, p2)
      end
    end
  end

  defp play_turn(p1, p2, x \\ nil, y \\ nil, tied \\ []) do
    x = x || Queue.dequeue(p1)
    y = y || Queue.dequeue(p2)
    cards = [x, y]

    cond do
      x > y -> {p1, cards ++ tied}
      x < y -> {p2, cards ++ tied}
      x == y -> war(p1, p2, cards ++ tied)
    end
  end

  defp war(p1, p2, tied) do
    [x, y] = Enum.take(tied, 2)
    tied = Enum.drop(tied, 2)

    cond do
      !able_to_war?(p1) ->
        cards = tied ++ Queue.flush(p1)
        push_cards(p2, cards)
        {p2, []}

      !able_to_war?(p2) ->
        cards = tied ++ Queue.flush(p2)
        push_cards(p1, cards)
        {p1, []}

      true ->
        {turn_winner, cards} = play_turn(p1, p2, x, y, tied)
        push_cards(turn_winner, cards)
        play_game(p1, p2)
    end
  end

  defp deal_player(card, {p1, p2}) do
    if length(p1) == length(p2) do
      {[apply_ace_weight(card) | p1], p2}
    else
      {p1, [apply_ace_weight(card) | p2]}
    end
  end

  defp able_to_war?(player) do
    Queue.size(player) > 3
  end

  # The game ends when a player losses all their cards
  # so their Stack is empty
  defp maybe_get_winner(player_1, player_2) do
    cond do
      Queue.size(player_1) == 0 -> player_2
      Queue.size(player_2) == 0 -> player_1
      true -> nil
    end
  end

  defp apply_ace_weight(card) do
    (card == 1 && @ace_weight) || card
  end

  defp remove_ace_weight(card) do
    (card == @ace_weight && 1) || card
  end

  # Cards won from a war needs to be pushed in descending order
  defp push_cards(player, cards) do
    cards = Enum.sort(cards, :desc)

    Queue.enqueue(player, cards)
  end
end
