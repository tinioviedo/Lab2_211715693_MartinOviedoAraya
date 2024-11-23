:- module('TDAboard_21171569_OviedoAraya', [board/1, can_play/1]).

% RF04 
% Dominio: No recibe parqmetros de entrada
% Metaprimaria: board/0
board([
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0]]).

% solo para probar es este
%tablero_lleno([
%    [1, 1, 1, 1, 1, 1, 1],
%    [1, 1, 1, 1, 1, 1, 1],
%    [1, 1, 1, 1, 1, 1, 1],
%    [1, 1, 1, 1, 1, 1, 1],
%    [1, 1, 1, 1, 1, 1, 1],
%    [1, 1, 1, 1, 1, 1, 1]]).

% RF05 - Verificar si se puede jugar
can_play(Board) :-
    mymember(Row, Board),      
    mymember(0, Row),       
     write('true'), nl,   % va a tirar true cuando encuentre un 0
    !.                        

% Si no se encuentra 0, retorna false
can_play(_) :- false.

% RF06 - Jugar una ficha en el tablero
% Meta primaria: play_piece/4

play_piece(Board, PlayerColumn, Piece, NewBoard) :-
    Column is PlayerColumn - 1,  % le resto 1 para que quede más intuitivo 
    Column >= 0, Column =< 6,  
    find_lowest_available_row(Board, Column, 0, LowestRow),
    piece_to_number(Piece, PieceNumber),
    update_board(Board, LowestRow, Column, PieceNumber, NewBoard).


% Convertir pieza a número el 1 para el rojo y el 2 pa amarillo
piece_to_number([Color], Number) :-
    (Color = "red" -> Number = 1;
     Color = "yellow" -> Number = 2).

% Encontrar la fila más baja disponible en una columna
find_lowest_available_row(Board, Column, CurrentRow, LowestRow) :-
    CurrentRow < 6,  % Verificar límite del tablero
    get_cell_value(Board, CurrentRow, Column, CellValue),
    CellValue = 0,  % Celda vacía encontrada
    NextRow is CurrentRow + 1,
    (NextRow = 6 ; 
     get_cell_value(Board, NextRow, Column, NextValue),
     NextValue \= 0), !,  % Siguiente celda ocupada o fin del tablero
    LowestRow = CurrentRow.

find_lowest_available_row(Board, Column, CurrentRow, LowestRow) :-
    CurrentRow < 5,
    NextRow is CurrentRow + 1,
    find_lowest_available_row(Board, Column, NextRow, LowestRow).

% Obtener valor de una celda específica del tablero
get_cell_value(Board, Row, Column, Value) :-
    get_row(Board, Row, RowList),
    get_column(RowList, Column, Value).

% Obtener fila específica del tablero
get_row(Board, 0, Row) :- first_at_list(Board, Row).
get_row(Board, 1, Row) :- second_at_list(Board, Row).
get_row(Board, 2, Row) :- third_at_list(Board, Row).
get_row(Board, 3, Row) :- fourth_at_list(Board, Row).
get_row(Board, 4, Row) :- fifth_at_list(Board, Row).
get_row(Board, 5, Row) :- sixth_at_list(Board, Row).

% Obtener valor de una columna en una fila
get_column(Row, 0, Value) :- first_at_list(Row, Value).
get_column(Row, 1, Value) :- second_at_list(Row, Value).
get_column(Row, 2, Value) :- third_at_list(Row, Value).
get_column(Row, 3, Value) :- fourth_at_list(Row, Value).
get_column(Row, 4, Value) :- fifth_at_list(Row, Value).
get_column(Row, 5, Value) :- sixth_at_list(Row, Value).
get_column(Row, 6, Value) :- seventh_at_list(Row, Value).

% Actualizar el tablero con una nueva pieza
update_board(Board, Row, Column, PieceNumber, NewBoard) :-
    get_row(Board, Row, CurrentRow),
    update_row(CurrentRow, Column, PieceNumber, UpdatedRow),
    replace_row(Board, Row, UpdatedRow, NewBoard).

% Actualizar una fila con un nuevo valor
update_row(Row, Column, Value, NewRow) :-
    update_list_position(Row, Column, Value, NewRow).

% Reemplazar una fila en el tablero
replace_row(Board, 0, NewRow, [NewRow|RestOfBoard]) :- 
    tail_at_list(Board, RestOfBoard).
replace_row([CurrentRow|RestOfBoard], Row, NewRow, [CurrentRow|UpdatedBoard]) :-
    Row > 0,
    NextRow is Row - 1,
    replace_row(RestOfBoard, NextRow, NewRow, UpdatedBoard).

% Actualizar posición en una lista
update_list_position([_|Rest], 0, Value, [Value|Rest]).
update_list_position([Current|Rest], Position, Value, [Current|NewRest]) :-
    Position > 0,
    NextPosition is Position - 1,
    update_list_position(Rest, NextPosition, Value, NewRest).





%-------------Funciones auxiliares----------------
%mymember
mymember(X, [X | _]).
mymember(X, [_ | Tail]) :-
    mymember(X, Tail).



% Insertar elemento al inicio de una lista
insertarInicio(Element, [], [Element]).
insertarInicio(Element, List, [Element | List]).


% Insertar elemento al final de una lista
insertarFinal(Element, [], [Element]).
insertarFinal(Element, [Head | Tail], [Head | NewTail]) :-
    insertarFinal(Element, Tail, NewTail).
% Selectores general
% first_at_list: Obtiene el primer elemento de una lista
first_at_list([First|_], First).

% second_at_list: Obtiene el segundo elemento de una lista
second_at_list([_,Second|_], Second).

% third_at_list: Obtiene el tercer elemento de una lista
third_at_list([_,_,Third|_], Third).

% fourth_at_list: Obtiene el cuarto elemento de una lista
fourth_at_list([_,_,_,Fourth|_], Fourth).

% fifth_at_list: Obtiene el quinto elemento de una lista
fifth_at_list([_,_,_,_,Fifth|_], Fifth).

% sixth_at_list: Obtiene el sexto elemento de una lista
sixth_at_list([_,_,_,_,_,Sixth|_], Sixth).

% seventh_at_list: Obtiene el séptimo elemento de una lista
seventh_at_list([_,_,_,_,_,_,Seventh|_], Seventh).

% last_at_list: Obtiene el último elemento de una lista
last_at_list([Last], Last).
last_at_list([_|Tail], Last) :- 
    last_at_list(Tail, Last).

% Tail_at_list: Obtiene el Tailo de la lista sin el primer elemento
Tail_at_list([_|Tail], Tail).

mylenght( [], 0 ).
mylenght( [_|Tail], Lenght) :-
	mylenght( Tail, LenghtAcum ),
	Lenght is LenghtAcum + 1.