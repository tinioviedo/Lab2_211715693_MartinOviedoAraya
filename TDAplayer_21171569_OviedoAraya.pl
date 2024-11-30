%RF02
%Descripcion: TDA Player - constructor. Predicado que permite crear un jugador.
%Dominio : id (int) X name (string) X color (string) X wins (int) X losses (int) X draws (int) X remaining_pieces (int) X Player.
%Metaprimaria: player/8.

player(Id, Name, Color, Wins, Losses, Draws, Remaining_pieces, [Id, Name, Color, Wins, Losses, Draws, Remaining_pieces]) :-
    integer(Id),
    string(Name), 
    (Color = "red" ; Color = "yellow"), 
    integer(Wins),
    integer(Losses),
    integer(Draws),
    integer(Remaining_pieces),
    Wins >= 0,
    Losses >= 0,
    Draws >= 0,
    Remaining_pieces =< 21.

   
%Selectores
get_id([Id, _, _, _, _, _, _], Id).
get_name([_, Name, _, _, _, _, _], Name).
get_color([_, _, Color, _, _, _, _], Color).
get_wins([_, _, _, Wins, _, _, _], Wins).
get_losses([_, _, _, _, Losses, _, _], Losses). 
get_draws([_, _, _, _, _, Draws, _], Draws).
get_remaining_pieces([_, _, _, _, _, _, Remaining_pieces], Remaining_pieces).

%RF14
%Descripcion: TDA Player - otros - actualizarEstadisticas actualiza estadísticas de un jugador después de un juego
%Dominio: Game X OldStats X NewStats
%Metaprimaria: update_stats/3.
%Metasecundaria: get_board/2, get_player1/2, get_player2/2, who_is_winner/2, update_player_stats/3.
update_stats(Game, Player, NewPlayer) :-
    get_board(Game, Board),
    get_player1(Game, Player1),
    get_player2(Game, Player2),
    who_is_winner(Board, Winner),
    (
        Winner = 1 -> (
            (Player = Player1 -> update_player_stats(Player, wins, NewPlayer) ;
             Player = Player2 -> update_player_stats(Player, losses, NewPlayer))
        );
        Winner = 2 -> (
            (Player = Player2 -> update_player_stats(Player, wins, NewPlayer) ;
             Player = Player1 -> update_player_stats(Player, losses, NewPlayer))
        );
        % Si no hay ganador, asume empate y actualiza draws para ambos jugadores
        Winner = 0 -> update_player_stats(Player, draws, NewPlayer)
    ).

%Funciones auxiliares para update_stats

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