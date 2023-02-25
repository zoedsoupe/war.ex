# War

<img src="https://github.com/zoedsoupe/war.ex/workflows/main/badge.svg?branch=main" />

## Game description

The game starts with a shuffled deck of cards. The deck will be passed into your program already shuffled (details below). The cards are dealt in an alternating fashion to each player, so that each player has 26 cards.

In each round, both players reveal the top card of their pile. The player with the higher card (by rank) wins both cards, placing them at the bottom of their pile. Aces are considered high, meaning the card ranks in ascending order are 2-10, Jack, Queen, King, Ace.

If the revealed cards are tied, there is war! Each player turns up one card face down followed by one card face up. The player with the higher face-up card takes both piles (six cards – the two original cards that were tied, plus the four cards from the war). If the turned-up cards are again the same rank, each player places another card face down and turns another card face up. The player with the higher card takes all 10 cards, and so on.

When one player runs out of cards, they are the loser, and the other the winner. If, during a war, a player runs out of cards, this counts as a loss as well.

More at the [official game description](https://bicyclecards.com/how-to-play/war)

## Technical details

### Input

The input to the program, representing a shuffled deck of cards, will be a permutation of 52 integers, where each integer between 1-13 occurs four times. The integers in this permutation correspond to cards according to the following table (four kings, four tens, four threes, and so on). Notice that we don’t bother representing the suit because the game of War doesn’t require it.

### The game

The program will deal two piles from the input permutation. How you represent your piles is completely up to you. Once the piles are dealt, “play” the game in your program until one player runs out of cards. Once again, how you manage your piles during the game is completely up to you. Keep going until one player runs out of cards.

When cards are added to the bottom of a player’s pile, they should be added in decreasing order by rank. That is, first place the highest ranked card on the bottom, then place the next highest ranked card beneath that. This is true of wars as well. If a player wins six cards as a result of a war, those cards should be added to the bottom starting with the highest rank and ending with the smallest. Ace has the highest rank, Two has the lowest.

### Output

The program will return the pile of the winning player. This pile should contain all 52 integers from the original input permutation and be in the correct order according to how the game played out.
