%Importa los archivos necesarios para el funcionamiento del programa
:- consult('TDAboard_21171569_OviedoAraya').
:- consult('TDAgame_21171569_OviedoAraya').
:- consult('TDApiece_21171569_OviedoAraya').
:- consult('TDAplayer_21171569_OviedoAraya').   

main :-
    write('--- Inicializacion del Juego ---'), nl,
    write('Jugadores Iniciales: '), nl,
    player(1, "Matias", "red", 0, 4, 1, 21, P1),
    write('Jugador 1: '), write(P1), nl,
    player(2, "Claudia", "yellow", 4, 0, 1, 21, P2),
    write('Jugador 2: '), write(P2), nl,

    piece("red", RedPiece),
    piece("yellow", YellowPiece),
    board(EmptyBoard),

    write('--- Tablero Inicial ---'), nl,
    write('Tablero vacio: '), write(EmptyBoard), nl,

    game(P1, P2, EmptyBoard, 1, G0),
    write('--- Verificacion de Juego Inicial ---'), nl,
    write('¿Se puede jugar en el tablero vacio? '), 
    ( can_play(EmptyBoard) -> writeln('Si, se puede jugar'); writeln('No se puede jugar') ), nl,

    write('--- Secuencia de Movimientos ---'), nl,
    player_play(G0, P1, 0, G1),
    player_play(G1, P2, 0, G2), 
    player_play(G2, P1, 1, G3), 
    player_play(G3, P2, 1, G4),
    player_play(G4, P1, 2, G5), 
    player_play(G5, P2, 2, G6),
    player_play(G6, P1, 3, G7),

    write('Despues de 7 movimientos: '), nl,
    get_current_player(G7, CurrentPlayer), 
    write('Jugador actual: '), write(CurrentPlayer), nl,

    game_get_board(G7, CurrentBoard),
    write('Tablero actual: '), write(CurrentBoard), nl,

    write('--- Verificaciones de Victoria ---'), nl,
    write('Victoria Vertical: '), 
    check_vertical_win(CurrentBoard, VerticalWinner), 
    write(VerticalWinner), nl,

    write('Victoria Horizontal: '), 
    check_horizontal_win(CurrentBoard, HorizontalWinner), 
    write(HorizontalWinner), nl,

    write('Victoria Diagonal: '), 
    check_diagonal_win(CurrentBoard, DiagonalWinner), 
    write(DiagonalWinner), nl,

    write('Ganador: '), 
    who_is_winner(CurrentBoard, Winner), 
    write(Winner), nl,

    write('¿Es empate? '), 
    ( is_draw(G7) -> writeln('No es empate'); writeln('Si, es empate') ), nl,

    end_game(G7, EndedGame),
    write('--- Resumen del Juego ---'), nl,
    write('Historial de movimientos: '), 
    game_history(EndedGame, History), nl,nl, write(History), nl,nl,nl,

    write('Jugadores actualizados, historial y tablero final del juego : '), nl,
    write(EndedGame), nl,
    game_get_board(EndedGame, FinalBoard), write(FinalBoard), nl.

