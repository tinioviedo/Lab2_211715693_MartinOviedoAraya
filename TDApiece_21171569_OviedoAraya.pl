%RF03
%Descripcion: TDA Piece - constructor que crea una ficha de Conecta4.
%Dominio: color (string)
%Metaprimaria: piece/2.

piece(Color, [Color]) :- 
    (Color = "red" ; Color = "yellow").
