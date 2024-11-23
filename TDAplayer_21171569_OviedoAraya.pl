:- module('TDAplayer_21171569_OviedoAraya', [
    player/8,
    get_id/2,
    get_name/2,
    get_color/2,
    get_wins/2,
    get_losses/2,
    get_draws/2,
    get_remaining_pieces/2
]).
% RF1
% Dominio : id (int) X name (string) X color (string) X wins (int) X losses (int) X draws (int) X remaining_pieces (int) X Player
% Metaprimaria: player/8

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
    Remaining_pieces >= 4,
    Remaining_pieces =< 21.
   
% Selectores
% get_id: Selecciona el id del jugador
get_id([Id, _, _, _, _, _, _], Id).

% get_name: Selecciona el nombre del jugador
get_name([_, Name, _, _, _, _, _], Name).

% get_color: Selecciona el color del jugador
get_color([_, _, Color, _, _, _, _], Color).

% get_wins: Selecciona el numero de victorias del jugador
get_wins([_, _, _, Wins, _, _, _], Wins).

% get_losses: Selecciona el numero de derrotas del jugador
get_losses([_, _, _, _, Losses, _, _], Losses). 

% get_draws: Selecciona el numero de empates del jugador
get_draws([_, _, _, _, _, Draws, _], Draws).

% get_remaining_pieces: Selecciona el numero de fichas restantes del jugador
get_remaining_pieces([_, _, _, _, _, _, Remaining_pieces], Remaining_pieces).