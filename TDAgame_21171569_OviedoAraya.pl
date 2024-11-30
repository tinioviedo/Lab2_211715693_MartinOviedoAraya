% ------------------------------------ TDA GAME ------------------------------------
%RF11
%Descripcion: TDA Game - Constructor crea un nuevo juego.
%Dominio : player1 (player) X player2 (player) X board (board) X current-turn (int) X history (list) X game
%Metaprimaria : game/5.

game(Player1, Player2, Board, CurrentTurn, NewGame) :-
    NewGame = [Player1, Player2, Board, CurrentTurn, []].

% implementar selectores
get_player1([Player1, _, _, _, _], Player1).
get_player2([_, Player2, _, _, _], Player2).
get_board([_, _, Board, _, _], Board).
get_current_turn([_, _, _, CurrentTurn, _], CurrentTurn).
get_history([_, _, _, _, History], History).

% -------------------------------------------------------------------------
%RF12
%Descripcion: TDA Game - otros - history. genera un historial de movimientos de la partida.
%Dominio : game (game) X historyCronology (list)
%Metaprimaria : game_history/2.
%Metasecundaria : reverse/2.
game_history(Game, HistoryCronology) :-
    (Game = [_, _, _, _, History] -> 
        reverse(History, HistoryCronology)
    ;   
        HistoryCronology = []
    ).


% -------------------------------------------------------------------------
%RF13
%Descripcion: TDA Game - Otros- Es Empate? Verificar si el juego es un empate
%Dominio : game (game) 
%Metaprimaria : is_draw/1
%Metasecundaria : can_play/1, no_pieces_left/1.
is_draw([_, Board, _, _, _]) :-
    \+ can_play(Board), 
    !.

is_draw([_, _, Player1, Player2, _]) :-
    no_pieces_left(Player1),
    no_pieces_left(Player2),  
    !.

is_draw(_, false). 


%Funciones auxiliares para is_draw
no_pieces_left([_, _, _, _, _, _, RemainingPieces]) :-
    RemainingPieces = 0.
% -------------------------------------------------------------------------

%RF15
%Descripcion: Selector - Obteniene el jugador actual
%Dominio: game X player
%Metaprimaria: get_current_player/2.
get_current_player([Player1, Player2, _, CurrentTurn, _], CurrentPlayer) :-
    (CurrentTurn = 1 -> CurrentPlayer = Player1;
     CurrentTurn = 2 -> CurrentPlayer = Player2).
% -------------------------------------------------------------------------
%RF16
%Descripcion: Selector - Obteniene el estado actual del tablero
%Dominio: game X board
%Metaprimaria: game_get_board/2.
game_get_board([_,_,Board,_,_], Board).

% -------------------------------------------------------------------------
%RF17
%Descripcion: Finaliza el juego actualizando las estadísticas.
%Dominio: game X endGame
%Metaprimaria: end_game/2.
%Metasecundaria: get_player1/2, get_player2/2, get_board/2, get_history/2, update_stats/3.
end_game(Game, EndGame) :-
    get_player1(Game, Player1),
    get_player2(Game, Player2),
    get_board(Game, Board),
    get_history(Game, History),  % Obtener el historial actual
    
    % Actualizar estadísticas del jugador 1
    update_stats(Game, Player1, UpdatedPlayer1),
    
    % Actualizar estadísticas del jugador 2
    update_stats(Game, Player2, UpdatedPlayer2),
    
    % Crear el nuevo juego manteniendo el historial
    EndGame = [UpdatedPlayer1, UpdatedPlayer2, Board, 0, History].

% -------------------------------------------------------------------------
%RF18
%Descripcion: TDA Game - modificador - realiza un movimiento
%Dominio: game X player X column X newGame
%Metaprimaria: player_play/4.
%Metasecundaria: verify_player_turn/3, get_current_turn/2, get_board/2, can_play/1, get_color/2, piece/2, play_piece/4, next_turn/2, update_player_pieces/2, update_game_state/6.
player_play(Game, Player, Column, NewGame) :-
    %Verificar que sea el turno del jugador correcto
    get_current_turn(Game, CurrentTurn),
    verify_player_turn(Game, Player, CurrentTurn),
    
    %tablero actual
    get_board(Game, Board),
    
    %verificar si se puede jugar
    can_play(Board),
    
    % Obtener la pieza del jugador
    get_color(Player, Color),
    piece(Color, Piece),
    
    %Jugar la pieza
    play_piece(Board, Column, Piece, NewBoard),
    
    %Determinar el próximo turno
    next_turn(CurrentTurn, NextTurn),
    get_player1(Game, Player1),
    verificar_id(Player, Player1),
    
    %Disminuir fichas jugador
    update_player_pieces(Player1, UpdatedPlayer),
    
    %Actualizar el estado del juego, pasando explícitamente la columna
    update_game_state(Game, UpdatedPlayer, NewBoard, NextTurn, NewGame, Column).


player_play(Game, Player, Column, NewGame) :-
    %Verificar que sea el turno del jugador correcto
    get_current_turn(Game, CurrentTurn),
    verify_player_turn(Game, Player, CurrentTurn),
    
    %tablero actual
    get_board(Game, Board),
    
    %verificar si se puede jugar
    can_play(Board),
    
    % Obtener la pieza del jugador
    get_color(Player, Color),
    piece(Color, Piece),
    
    %Jugar la pieza
    play_piece(Board, Column, Piece, NewBoard),
    
    %Determinar el próximo turno
    next_turn(CurrentTurn, NextTurn),
    get_player2(Game, Player2),
    verificar_id(Player, Player2),
    

    %Disminuir fichas jugador
    update_player_pieces(Player2, UpdatedPlayer),
    
    %Actualizar el estado del juego, pasando explícitamente la columna
    update_game_state(Game, UpdatedPlayer, NewBoard, NextTurn, NewGame, Column).

%Funciones auxiliares para player_play


% verificar id
verificar_id([Id1, _, _, _, _, _, _],[Id2, _, _, _, _, _, _]):-
    Id1 == Id2.



%Verificando el turno del jugador
verify_player_turn(Game, Player, CurrentTurn) :-
    (CurrentTurn = 1 -> 
        get_player1(Game, ExpectedPlayer);
     CurrentTurn = 2 -> 
        get_player2(Game, ExpectedPlayer)
    ),
    get_id(Player, PlayerId),
    get_id(ExpectedPlayer, ExpectedPlayerId),
    PlayerId = ExpectedPlayerId.

%Cambiar el turno
next_turn(1, 2).
next_turn(2, 1).

%Disminuir fichas del jugador
update_player_pieces(
    [Id, Name, Color, Wins, Losses, Draws, RemainingPieces], 
    [Id, Name, Color, Wins, Losses, Draws, NewRemainingPieces]) :- 
    NewRemainingPieces is RemainingPieces - 1.

%Modificar update_game_state para guardar columna y color correctamente
update_game_state([P1, P2, _, CurrentTurn, History], 
CurrentPlayer, NewBoard, NextTurn,[UpdatedP1, UpdatedP2, NewBoard, NextTurn, NewHistory],Column) :- 
    %Determinar el jugador actual y el otro jugador
    (CurrentTurn = 1 -> 
        UpdatedP1 = CurrentPlayer,
        UpdatedP2 = P2
    ; 
        UpdatedP1 = P1,
        UpdatedP2 = CurrentPlayer
    ),
    
    %Obtener el color del jugador actual
    get_color(CurrentPlayer, Color),
    
    %Agregar la tupla [columna, color] al inicio del historial
    insertarInicio([Column, Color], History, NewHistory).



















%Predicado auxiliar para obtener la última columna
get_last_column([], 0).  % valor por defecto si no hay historial
get_last_column([[Column, _]|_], Column).
check_game_end(Game) :-
    get_board(Game, Board),
    (who_is_winner(Board, Winner), Winner \= 0 ->
        true;
     is_draw(Game, true) ->
        true;
     false
    ).




    








