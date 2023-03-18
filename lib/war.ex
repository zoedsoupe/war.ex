defmodule War do
  @doc """
  The main module to the challenge.
  This module exposes a deal/1 function to play the game.
  """

  # prefers to use a weight as we don't
  # need to represent the card suite
  @ace_weight 14

  def deal(deck) do
    {p1, p2} =
      deck
      |> Enum.map(&apply_ace_weight/1)
      |> Enum.reverse()
      |> deal_deck()

    winner = play_game(p1, p2)

    Enum.map(winner, &remove_ace_weight/1)
  end

  def deal_deck(deck) do
    {Enum.take_every(deck, 2), Enum.drop_every(deck, 2)}
  end

  defp play_game(p1, p2, tied \\ [])

  defp play_game([], [], tied), do: Enum.sort(tied, :desc)
  defp play_game([], p2, tied), do: p2 ++ Enum.sort(tied, :desc)
  defp play_game(p1, [], tied), do: p1 ++ Enum.sort(tied, :desc)

  # Normal game turn
  defp play_game([x | xs], [y | ys], tied) do
    cards = Enum.sort([x, y] ++ tied, :desc)

    cond do
      x > y ->
        play_game(xs ++ cards, ys)

      x < y ->
        play_game(xs, ys ++ cards)

      xs != [] and ys != [] ->
        [fc_down1 | xs] = xs
        [fc_down2 | ys] = ys
        play_game(xs, ys, cards ++ [fc_down1, fc_down2])

      true ->
        play_game(xs, ys, cards)
    end
  end

  defp apply_ace_weight(card) do
    (card == 1 && @ace_weight) || card
  end

  defp remove_ace_weight(card) do
    (card == @ace_weight && 1) || card
  end
end
