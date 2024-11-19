%RF11 
% Dominio : player1 (player) X player2 (player) X board (board) X current-turn (int)
game(Game, Board, Player1, Player2, CurrentTurn, NewGame) :-
    NewGame = [Player1, Player2, Board, CurrentTurn].

% implementar selectores
% get_board: Selecciona el tablero

get_board(|[_, _, Board, _], Board).

% get_player1: Selecciona el jugador 1
get_player1(|[Player1, _, _, _], Player1).

% get_player2: Selecciona el jugador 2
get_player2(|[_, Player2, _, _], Player2).

% get_current_turn: Selecciona el turno actual
get_current_turn(|[_, _, _, CurrentTurn], CurrentTurn).
