%RF11 

game(Player1, Player2,Board, CurrentTurn, NewGame) :-
    NewGame = [Player1, Player2, Board, CurrentTurn].

% implementar selectores
get_player1([Player1, _, _, _], Player1).
get_player2([_, Player2, _, _], Player2).
get_board([_, _, Board, _], Board).
get_current_turn([_, _, _, CurrentTurn], CurrentTurn).

% RF12 - TDA Game - Otros- Es Empate?

is_draw(Game) :-
    get_board(Game, Board),
    \+ can_play(Board),
    who_is_winner(Board, Winner),
    Winner = 0.




    








