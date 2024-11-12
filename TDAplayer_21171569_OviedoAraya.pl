%RF1

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
    Remaining_pieces >= 4.
    