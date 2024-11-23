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


% RF05

can_play(Board) :- 
    board(Board),         
    mymember(Row, Board),  
    mymember(0, Row).     


% RF06
% Dominio: Board X Column X Piece X NewBoard
% Metaprimaria: play_piece/4
play_piece(Board, Column, Piece, NewBoard) :-
    board(Board),
    can_play(Board),
    mymember(Column, [1,2,3,4,5,6,7]),
    get_column(Board, Column, ColumnList),
    mymember(0, ColumnList),     % Verificar que la columna no esté llena (tiene al menos un 0)
    find_lowest_empty_row(ColumnList, RowPosition),
    update_column_at_position(ColumnList, RowPosition, Piece, UpdatedColumn),
    update_board_column(Board, Column, UpdatedColumn, NewBoard).
    
    
% da el índice de la posición más baja disponible
% Metaprimaria: find_lowest_empty_row/2
find_lowest_empty_row(ColumnList, RowPosition) :-
    find_last_zero_position(ColumnList, 0, RowPosition).

% da el índice del último cero
% Metaprimaria: find_last_zero_position/3
find_last_zero_position([], _, -1).
find_last_zero_position([0|Tail], CurrentPosition, LastZeroPosition) :-
    NextPosition is CurrentPosition + 1,
    find_last_zero_position(Tail, NextPosition, PrevLastZeroPosition),
    (PrevLastZeroPosition = -1 -> LastZeroPosition = CurrentPosition 
                             ;  LastZeroPosition = PrevLastZeroPosition).
find_last_zero_position([_|Tail], CurrentPosition, LastZeroPosition) :-
    NextPosition is CurrentPosition + 1,
    find_last_zero_position(Tail, NextPosition, LastZeroPosition).

% Reemplazar un elemento en un índice específico de una lista
% Metaprimaria: update_column_at_position/4
update_column_at_position(List, Position, NewElement, NewList) :-
    update_list_element(List, Position, NewElement, NewList, 0).

% Función auxiliar de reemplazo recursivo
% Metaprimaria: update_list_element/5
update_list_element([], _, _, [], _).
update_list_element([_|Tail], Position, NewElement, [NewElement|Tail], Position) :- !.
update_list_element([Head|Tail], Position, NewElement, [Head|NewTail], CurrentPosition) :-
    NextPosition is CurrentPosition + 1,
    update_list_element(Tail, Position, NewElement, NewTail, NextPosition).


% get_column(Board, ColumnNum, ListColumn)

get_column(Board, ColumnNum, Column) :-
    findall(Element, (mymember(Row, Board),
    get_element_at(Row, ColumnNum, Element)), 
    Column).

% update_board_column(Board, ColumnNum, NewColumn, NewBoard)    
update_board_column(Board, ColumnNum, NewColumn, NewBoard) :-
    update_board_column(Board, ColumnNum, NewColumn, NewBoard, 1).


% Predicado auxiliar para seleccionar el elemento según el número de columna
get_element_at(Row, 1, Element) :- 
first_at_list(Row, Element).
get_element_at(Row, 2, Element) :- 
second_at_list(Row, Element).
get_element_at(Row, 3, Element) :- 
third_at_list(Row, Element).
get_element_at(Row, 4, Element) :- 
fourth_at_list(Row, Element).
get_element_at(Row, 5, Element) :- 
fifth_at_list(Row, Element).
get_element_at(Row, 6, Element) :- 
sixth_at_list(Row, Element).
get_element_at(Row, 7, Element) :- 
seventh_at_list(Row, Element).


% RF07 - Verificar victoria vertical
% Dominio: Board X Winner
% Metaprimaria: vertical_winner/2
check_vertical_win(Board, Winner) :-

% Verifica victoria vertical para un jugador específico
check_vertical_win_for_player(Board, Player) :-
    between(1, 7, Column),
    get_column(Board, Column, ColumnList),
    cuatro_consecutivas(ColumnList, Player).

% Verifica si hay 4 fichas consecutivas del mismo jugador
cuatro_consecutivas([Player,Player,Player,Player|_], Player) :-
    Player \= 0.
cuatro_consecutivas([_|Resto], Player) :-
    cuatro_consecutivas(Resto, Player).





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