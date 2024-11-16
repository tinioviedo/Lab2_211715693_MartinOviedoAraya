% RF1
% Dominio : id (int) X name (string) X color (string) X wins (int) X losses (int) X draws (int) X remaining_pieces (int) X Player
% Metaprimaria/8

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
    Remaining_pieces < 21.
    
    
% Selectores
get_id([Id, _, _, _, _, _, _], Id).
% get_id: Selecciona el id del jugador
% Dominio: 
% 
% Recorrido: id: entero
% 
get_name([_, Name, _, _, _, _, _], Name).
% get_name: Selecciona el nombre del jugador
% Dominio:
%
% Recorrido: Name: string

get_color([_, _, Color, _, _, _, _], Color).
% get_color: Selecciona el color del jugador
% Dominio:
%
% Recorrido: Color: string

get_wins([_, _, _, Wins, _, _, _], Wins).
% get_wins: Selecciona el numero de victorias del jugador
% Dominio:

% Recorrido: Wins: entero

get_losses([_, _, _, _, Losses, _, _], Losses). 
% get_losses: Selecciona el numero de derrotas del jugador
% Dominio:

% Recorrido: Losses: entero

get_draws([_, _, _, _, _, Draws, _], Draws).
% get_draws: Selecciona el numero de empates del jugador
% Dominio:

% Recorrido: Draws: entero

get_remaining_pieces([_, _, _, _, _, _, Remaining_pieces], Remaining_pieces).
% get_remaining_pieces: Selecciona el numero de fichas restantes del jugador
% Dominio: 

% Recorrido: Remaining_pieces: entero