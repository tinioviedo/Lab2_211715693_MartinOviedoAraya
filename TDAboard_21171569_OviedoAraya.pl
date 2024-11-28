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

% -------------------------------------------------------------------------

% RF05 - Verificar si se puede jugar
can_play(Board) :-
    mymember(Row, Board),       % Buscamos en las filas
    mymember(0, Row).           % Buscamos un 0

% Si no se encuentra ningún 0, retorna false
can_play(_) :- false.

% -------------------------------------------------------------------------
% RF06 - Jugar una ficha en el tablero

play_piece(Board, PlayerColumn, Piece, NewBoard) :-
    PlayerColumn >= 0, 
    PlayerColumn =< 6,  
    find_lowest_available_row(Board, PlayerColumn, 0, LowestRow),
    piece_to_number(Piece, PieceNumber),
    update_board(Board, LowestRow, PlayerColumn, PieceNumber, NewBoard).


% Convertir pieza a número (1=rojo, 2=amarillo)
piece_to_number([Color], Number) :-
    (Color = "red" -> Number = 1;
     Color = "yellow" -> Number = 2).

% Encontrar la fila más baja disponible en una columna
find_lowest_available_row(Board, Column, CurrentRow, LowestRow) :-
    CurrentRow < 6,
    get_cell_value(Board, CurrentRow, Column, CellValue),
    CellValue = 0,  
    NextRow is CurrentRow + 1,
    (NextRow = 6 ; 
     get_cell_value(Board, NextRow, Column, NextValue),
     NextValue \= 0), !,
    LowestRow = CurrentRow.

find_lowest_available_row(Board, Column, CurrentRow, LowestRow) :-
    CurrentRow < 5,
    NextRow is CurrentRow + 1,
    find_lowest_available_row(Board, Column, NextRow, LowestRow).

% Obtener valor de una posición específica del tablero
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

% -------------------------------------------------------------------------
% RF07 - Verificar si hay un ganador vertical

% Verificar victoria vertical

check_vertical_win(Board, Winner) :-
    mymember(Column, [0,1,2,3,4,5,6]),  % para el vertial tengo que iterar sobre los índices, para el horizotal se podrá poner el Board altiro.
    get_column(Board, Column, ColumnValues),   
    check_consecutive_four(ColumnValues, Winner). 
% caso base
check_vertical_win(_, 0).
% Extraer una columna completa del tablero
get_column(Board, ColumnPosition, Column) :-
    findall(Value, (mymember(Row, Board),get_position_in_row(Row, ColumnPosition, Value)),Column).


% -------------------------------------------------------------------------
% RF08 - Verificar si hay un ganador horizontal
check_horizontal_win(Board, Winner) :-
    mymember(Row, Board),       
    check_consecutive_four(Row, Winner),
    Winner \= 0.  % Aseguramos que el ganador no sea 0

check_horizontal_win(_, 0).  % Caso base, si no encuentra ganador retorna 0

% Verificar si hay 4 consecutivos iguales en una lista (fila)
check_consecutive_four([Value,Value,Value,Value|_], Value) :- 
    Value \= 0.  
check_consecutive_four([_|Rest], Winner) :-       
    check_consecutive_four(Rest, Winner).

% -------------------------------------------------------------------------

% RF09 - Verificar si hay un ganador diagonal
check_diagonal_win(Board, Winner) :-
    (check_up_diagonal(Board, Winner);
     check_down_diagonal(Board, Winner)),
    Winner \= 0, !.

check_diagonal_win(_, 0). % Caso base, no hay ganador diagonal
% Diagonal ascendente
check_up_diagonal(Board, Winner) :-
    between(3, 5, Row),   
    between(0, 3, Col),   
    get_cell_value(Board, Row, Col, Value),
    Value \= 0,
    R1 is Row - 1,
    R2 is Row - 2,
    R3 is Row - 3,
    C1 is Col + 1,
    C2 is Col + 2,
    C3 is Col + 3,
    get_cell_value(Board, R1, C1, Value),
    get_cell_value(Board, R2, C2, Value),
    get_cell_value(Board, R3, C3, Value),
    Winner = Value.

% Diagonal descendente
check_down_diagonal(Board, Winner) :-
    between(0, 2, Row),  
    between(0, 3, Col),   
    get_cell_value(Board, Row, Col, Value),
    Value \= 0,
    R1 is Row + 1,
    R2 is Row + 2,
    R3 is Row + 3,
    C1 is Col + 1,
    C2 is Col + 2,
    C3 is Col + 3,
    get_cell_value(Board, R1, C1, Value),
    get_cell_value(Board, R2, C2, Value),
    get_cell_value(Board, R3, C3, Value),
    Winner = Value.

% -------------------------------------------------------------------------
% RF10  TDA Board - otros - entregarGanador, Requisitos de implementación Utilizar las predicados de verificación vertical, horizontal y diagonal para determinar si hay un ganador. Un ganador puede ser vertical, horizontal o diagonal. Realizar de forma declarativa. Dominio board (Board) 9 Recorrido int (1 si gana jugador 1, 2 si gana jugador 2, 0 si no hay ganador vertical) Ejemplo de uso who_is_winner(Board, Winner)
who_is_winner(Board, Winner) :-
    (check_vertical_win(Board, Winner), Winner \= 0;
    check_horizontal_win(Board, Winner), Winner \= 0;
    check_diagonal_win(Board, Winner), Winner \= 0),
    !.
% caso base
who_is_winner(_, 0).



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