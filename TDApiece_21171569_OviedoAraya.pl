% RF2
% Dominio: color (string)
% Metaprimaria: piece/2.




piece(Color, [Color]) :- 
    (Color = "red" ; Color = "yellow").