defmodule War do
  @doc """
  The main module to the challenge.
  This module exposes a deal/1 function to play the game.

  You can run all tests executing `elixir war.ex`.
  """

  # prefers to use a weight as we don't
  # need to represent the card suite
  @ace_weight 14

  def deal(deck) do
    {d1, d2} = deal_deck(deck)

    p1 = Player.new(d1)
    p2 = Player.new(d2)

    winner = play_game(p1, p2)

    Enum.map(Player.flush_deck(winner), &remove_ace_weight/1)
  end

  def deal_deck(deck) do
    List.foldr(deck, {[], []}, &deal_player/2)
  end

  defp deal_player(card, {p1, p2}) do
    if length(p1) == length(p2) do
      {[apply_ace_weight(card) | p1], p2}
    else
      {p1, [apply_ace_weight(card) | p2]}
    end
  end

  defp play_game(p1, p2, x \\ nil, y \\ nil, tied \\ []) do
    if winner = maybe_get_winner(p1, p2) do
      :ok = Player.add_to_pile(winner, tied)
      :ok = Player.add_pile_to_deck(winner)

      winner
    else
      x = maybe_remove_top(p1, x)
      y = maybe_remove_top(p2, y)

      cards = [x, y] ++ tied

      cond do
        x > y ->
          Player.add_to_pile(p1, cards)
          play_game(p1, p2)

        x < y ->
          Player.add_to_pile(p2, cards)
          play_game(p1, p2)

        x == y ->
          war(p1, p2, cards ++ tied)
      end
    end
  end

  defp maybe_remove_top(p, nil), do: Player.remove_top(p)
  defp maybe_remove_top(_, card), do: card

  defp war(p1, p2, tied) do
    [n1, d1] = Player.remove_for_war(p1)
    [n2, d2] = Player.remove_for_war(p2)

    play_game(p1, p2, n1, n2, tied ++ [d1, d2])
  end

  defp able_to_war?(player) do
    Player.deck_size(player) > 3
  end

  # The game ends when a player losses all their cards
  # so their Stack is empty
  defp maybe_get_winner(p1, p2) do
    cond do
      Player.deck_size(p1) == 0 -> p2
      Player.deck_size(p2) == 0 -> p1
      true -> nil
    end
  end

  defp apply_ace_weight(card) do
    (card == 1 && @ace_weight) || card
  end

  defp remove_ace_weight(card) do
    (card == @ace_weight && 1) || card
  end
end
