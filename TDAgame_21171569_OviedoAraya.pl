%RF11

game(Game, Board, Player1, Player2, CurrentTurn, NewGame) :-
    NewGame = [Player1, Player2, Board, CurrentTurn].