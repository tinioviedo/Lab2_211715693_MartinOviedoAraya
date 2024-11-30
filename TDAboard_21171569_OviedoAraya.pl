%RF04
%Descripcion: TDA Board - constructor que crea un tablero de Conecta4 vacío.
%Dominio: no hay parametros de entrada.
%Metaprimaria: board/1.
board([
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0]]).


% -------------------------------------------------------------------------

%RF05 
%Descripcion:  Verifica si se puede jugar.
%Dominio: board (board)
%Metaprimaria: can_play/1.
can_play(Board) :-
    mymember(Row, Board),       %Buscamos en las filas
    mymember(0, Row).           %Buscamos un 0

%Si no se encuentra ningún 0, retorna false
can_play(_) :- false.

% -------------------------------------------------------------------------
%RF06 
%Descripcion:  Realiza un movimiento en el tablero.
%Dominio: board (board) X playerColumn (int) X piece (piece) X newBoard (board)
%Metaprimaria: play_piece/4.
%Metasecundaria: find_lowest_available_row/4, piece_to_number/2, update_board/5.

play_piece(Board, PlayerColumn, Piece, NewBoard) :-
    PlayerColumn >= 0, 
    PlayerColumn =< 6,  
    find_lowest_available_row(Board, PlayerColumn, 0, LowestRow),
    piece_to_number(Piece, PieceNumber),
    update_board(Board, LowestRow, PlayerColumn, PieceNumber, NewBoard).

%Funciones auxiliares para play_piece

%Convertir pieza a número (1=rojo, 2=amarillo)
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
update_list_position([_|Tail], 0, Value, [Value|Tail]).
update_list_position([Current|Tail], Position, Value, [Current|NewTail]) :-
    Position > 0,
    NextPosition is Position - 1,
    update_list_position(Tail, NextPosition, Value, NewTail).

% -------------------------------------------------------------------------
% RF07 
% Descripción: Verifica si hay un ganador vertical.
% Dominio: board (board) X winner (int)
% Metaprimaria: check_vertical_win/2.
% Metasecundaria: check_vertical_win_aux/3.

check_vertical_win(Board, Winner) :-
    check_vertical_win_aux(Board, 0, Winner).

% Función auxiliar recursiva para verificar columnas
check_vertical_win_aux(Board, Column, Winner) :-
    Column =< 6,
    get_column(Board, Column, ColumnValues),
    (check_consecutive_four(ColumnValues, Winner) -> true
    ; NextColumn is Column + 1,
      check_vertical_win_aux(Board, NextColumn, Winner)).

% Caso base: no hay ganador vertical
check_vertical_win_aux(_, 7, 0).

%Funciones auxiliares para check_vertical_win
get_column(Board, ColumnPosition, Column) :-
    findall(Value, (mymember(Row, Board),get_position_in_row(Row, ColumnPosition, Value)),Column).

% -------------------------------------------------------------------------
% RF08
% Descripción: Verificar si hay un ganador horizontal.
% Dominio: board (board) X winner (int)
check_horizontal_win(Board, Winner) :-
    check_horizontal_win_aux(Board, 0, Winner).

% Función auxiliar recursiva
check_horizontal_win_aux(Board, RowIndex, Winner) :-
    RowIndex =< 5,  % Recorrer filas de 0 a 5
    get_row(Board, RowIndex, Row),
    (check_consecutive_four(Row, Winner) -> true
    ; NextRowIndex is RowIndex + 1,
      check_horizontal_win_aux(Board, NextRowIndex, Winner)).

% Caso base: no hay ganador horizontal
check_horizontal_win_aux(_, 6, 0).

%Funciones auxiliares para check_horizontal_win

% Verificar si hay 4 consecutivos iguales en una lista (fila)
check_consecutive_four([Value,Value,Value,Value|_], Value) :- 
    Value \= 0.  
check_consecutive_four([_|Tail], Winner) :-       
    check_consecutive_four(Tail, Winner).


% -------------------------------------------------------------------------

%RF09 
%Descripcion: Verificar si hay un ganador diagonal.
%Dominio: board (board) X winner (int)
%Metaprimaria: check_diagonal_win/2.
%Metasecundaria: check_up_diagonal/2, check_down_diagonal/2.
% RF09 - Verificar si hay un ganador diagonal
check_diagonal_win(Board, Winner) :-
    (check_up_diagonal(Board, Winner);
     check_down_diagonal(Board, Winner)),
    Winner \= 0, !.

check_diagonal_win(_, 0). % Caso base, no hay ganador diagonal

%Funciones auxiliares para check_diagonal_win
% Diagonal ascendente
check_up_diagonal(Board, Winner) :-
    recursive_up(Board, 3, 0, Winner).

% Caso base de recursión ascendente
recursive_up(_, Row, _, 0) :- Row > 5, !.
recursive_up(_, _, Col, 0) :- Col > 3, !.

% Verificación de una diagonal ascendente
recursive_up(Board, Row, Col, Winner) :-
    Row =< 5, Col =< 3,
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
    Winner = Value, !.

% Continuar buscando si no se encuentra una diagonal ascendente
recursive_up(Board, Row, Col, Winner) :-
    Col =< 3,
    Col1 is Col + 1,
    recursive_up(Board, Row, Col1, Winner).

recursive_up(Board, Row, _, Winner) :-
    Row =< 5,
    Row1 is Row + 1,
    recursive_up(Board, Row1, 0, Winner).

% Diagonal descendente
check_down_diagonal(Board, Winner) :-
    recursive_down(Board, 0, 0, Winner).

% Caso base de recursión descendente
recursive_down(_, Row, _, 0) :- Row > 2, !.
recursive_down(_, _, Col, 0) :- Col > 3, !.

% Verificación de una diagonal descendente
recursive_down(Board, Row, Col, Winner) :-
    Row =< 2, Col =< 3,
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
    Winner = Value, !.

% Continuar buscando si no se encuentra una diagonal descendente
recursive_down(Board, Row, Col, Winner) :-
    Col =< 3,
    Col1 is Col + 1,
    recursive_down(Board, Row, Col1, Winner).

recursive_down(Board, Row, _, Winner) :-
    Row =< 2,
    Row1 is Row + 1,
    recursive_down(Board, Row1, 0, Winner).


% -------------------------------------------------------------------------
%RF10
%Descripcion : TDA Board - otros - entregarGanador
%Dominio : board (board) X winner (int)
%Metaprimaria : who_is_winner/2.
%Metasecundaria : check_vertical_win/2, check_horizontal_win/2, check_diagonal_win/2.
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

% tail_at_list: Obtiene el Tail de la lista sin el primer elemento
tail_at_list([_|Tail], Tail).

mylenght( [], 0 ).
mylenght( [_|Tail], Lenght) :-
	mylenght( Tail, LenghtAcum ),
	Lenght is LenghtAcum + 1.