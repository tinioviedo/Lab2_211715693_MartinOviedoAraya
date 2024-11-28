% ------------------------------------ TDA GAME ------------------------------------
% RF11 - TDA Game - Crear un juego 10. RF11. (0.1 pts) TDA Game - constructor. Predicado que permite crear una nueva

% Dominio : player1 (player) X player2 (player) X board (board) X current-turn (int)
game(Player1, Player2, Board, CurrentTurn, NewGame) :-
    NewGame = [Player1, Player2, Board, CurrentTurn, []].
% implementar selectores
get_player1([Player1, _, _, _, _], Player1).
get_player2([_, Player2, _, _, _], Player2).
get_board([_, _, Board, _, _], Board).
get_current_turn([_, _, _, CurrentTurn, _], CurrentTurn).
get_history([_, _, _, _, History], History).

% -------------------------------------------------------------------------
%RF12. (0.1 pts) TDA Game - otros - history. Predicado que genera un historial de movimientos de la partida.
game_history(Game, HistoryCronology) :-
    (Game = [_, _, _, _, History] -> 
        reverse(History, HistoryCronology)
    ;   % para  el caso que no haya historial , se retorna una lista vacía
        HistoryCronology = []
    ).




% -------------------------------------------------------------------------
% RF13 - TDA Game - Otros- Es Empate?
% Verificar si el juego es un empate
% is_draw(Game, IsDraw).
is_draw([_, Board, _, _, _]) :-
    \+ can_play(Board),  % Tablero lleno
    !.

is_draw([_, _, Player1, Player2, _]) :-
    no_pieces_left(Player1),
    no_pieces_left(Player2),  % Ambos jugadores sin fichas
    !.

is_draw(_, false).  % En caso contrario, no es empate.


% no_pieces_left(Player).
no_pieces_left([_, _, _, _, _, _, RemainingPieces]) :-
    RemainingPieces = 0.


% -------------------------------------------------------------------------
% RF14 - TDA Player - otros - actualizarEstadisticas
% Dominio: Game X OldStats X NewStats
% Predicado para actualizar estadísticas de un jugador después de un juego
update_stats(Game, Player, NewPlayer) :-
    get_board(Game, Board),
    get_player1(Game, Player1),
    get_player2(Game, Player2),
    who_is_winner(Board, Winner),
    % Gana el jugador 1
    (Winner = 1 -> ((Player = Player1 -> update_player_stats(Player, wins, NewPlayer) ;
                    Player = Player2 -> update_player_stats(Player, losses, NewPlayer)));
    % Gana el jugador 2 
    Winner = 2 -> ((Player = Player2 -> update_player_stats(Player, wins, NewPlayer) ;
                   Player = Player1 -> update_player_stats(Player, losses, NewPlayer)));
    % Empatan
    is_draw(Game, true) -> (update_player_stats(Player, draws, NewPlayer))).

% Actualizar estadísticas del jugador
update_player_stats(
    [Id, Name, Color, Wins, Losses, Draws, RemainingPieces], 
    wins, 
    [Id, Name, Color, NewWins, Losses, Draws, RemainingPieces]) :- 
    NewWins is Wins + 1.
update_player_stats(
    [Id, Name, Color, Wins, Losses, Draws, RemainingPieces], 
    losses, 
    [Id, Name, Color, Wins, NewLosses, Draws, RemainingPieces]) :- 
    NewLosses is Losses + 1.
update_player_stats(
    [Id, Name, Color, Wins, Losses, Draws, RemainingPieces], 
    draws, 
    [Id, Name, Color, Wins, Losses, NewDraws, RemainingPieces]) :- 
    NewDraws is Draws + 1.




    








