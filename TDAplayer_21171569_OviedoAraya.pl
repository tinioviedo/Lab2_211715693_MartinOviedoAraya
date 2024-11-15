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
    