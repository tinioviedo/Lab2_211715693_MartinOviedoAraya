% RF04
% Dominio: No recibe parqmetros de entrada
% Metaprimaria/0

board([
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0]]).


% RF05
% Dominio: board (board)
can_play(CurrentBoard)
:- member(0, CurrentBoard).
