:- module('TDAboard_21171569_OviedoAraya', [board/1, can_play/1]).


% RF04 - Tablero inicial
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
     write('true'), nl,   % Imprimir true cuando se puede jugar
    !.                       

% Si no se encuentra 0, retorna false
can_play(_) :- false.

% RF06 - Jugar una ficha en el tablero

play_piece(Board, PlayerColumn, Piece, NewBoard) :-
    % Ajustar la columna del jugador (1-7) a índices internos (0-6)
    Column is PlayerColumn - 1,  
    Column >= 0, Column =< 6,  % Verificar si está dentro del rango
    find_lowest_available_row(Board, Column, 0, LowestRow),
    piece_to_number(Piece, PieceNumber),
    update_board(Board, LowestRow, Column, PieceNumber, NewBoard).


% Convertir pieza a número el 1 para el rojo y el 2 para el amarillo
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
    get_position_in_row(RowList, Column, Value).

% Obtener fila específica del tablero
get_row(Board, 0, Row) :- first_at_list(Board, Row).
get_row(Board, 1, Row) :- second_at_list(Board, Row).
get_row(Board, 2, Row) :- third_at_list(Board, Row).
get_row(Board, 3, Row) :- fourth_at_list(Board, Row).
get_row(Board, 4, Row) :- fifth_at_list(Board, Row).
get_row(Board, 5, Row) :- sixth_at_list(Board, Row).

% Obtener valor de una columna en una fila
get_position_in_row(Row, 0, Value) :- first_at_list(Row, Value).
get_position_in_row(Row, 1, Value) :- second_at_list(Row, Value).
get_position_in_row(Row, 2, Value) :- third_at_list(Row, Value).
get_position_in_row(Row, 3, Value) :- fourth_at_list(Row, Value).
get_position_in_row(Row, 4, Value) :- fifth_at_list(Row, Value).
get_position_in_row(Row, 5, Value) :- sixth_at_list(Row, Value).
get_position_in_row(Row, 6, Value) :- seventh_at_list(Row, Value).

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

% RF07 - Verificar si hay un ganador vertical

% Verificar victoria vertical
% caso base
check_vertical_winner(_, 0).
check_vertical_winner(Board, Winner) :-
    mymember(Column, [0,1,2,3,4,5,6]),  % para el vertial tengo que iterar sobre los índices, para el horizotal se podrá poner el Board altiro.
    get_column(Board, Column, ColumnValues),   
    check_consecutive_four(ColumnValues, Winner). 

% Extraer una columna completa del tablero
get_column(Board, ColumnPosition, Column) :-
    findall(Value, (mymember(Row, Board),get_position_in_row(Row, ColumnPosition, Value)),Column).
% Verificar si hay 4 consecutivos iguales en una lista (columna)
check_consecutive_four([Value,Value,Value,Value|_], Value) :- Value \= 0.  
check_consecutive_four([_|Rest], Winner) :-       
    check_consecutive_four(Rest, Winner).

% RF08 - Verificar si hay un ganador horizontal
% caso base
check_horizontal_win(_, 0).
check__horizontal_winner(Board, Winner) :-
    mymember(Row, Board),       
    check_consecutive_four(Row, Winner).
% RF09 - Verificar si hay un ganador diagonal
% caso base
check_diagonal_winner(_, 0).
% Se supone que se puede ganar en forma ascendente y descendente
% Ver si hay 4 consecutivos en diagonal ascendente, donde tendria que aumentar la columna y disminuir la fila en cada paso
% Ver si hay 4 consecutivos en diagonal descendente, donde tendria que aumentar la columna y aumentar la fila en cada paso
check_diagonal_win(Board, Winner) :-
    (check_ascending_diagonal(Board, Winner);
     check_descending_diagonal(Board, Winner)).



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