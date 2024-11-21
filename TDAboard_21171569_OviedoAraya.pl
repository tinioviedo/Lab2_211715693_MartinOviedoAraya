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
play_piece(Board, Column, Piece, NewBoard) :-
    board(Board),
    can_play(Board),
    mymember(Column, [1,2,3,4,5,6,7]),
    get_column(Board, Column, ColumnList),
    mymember(0, ColumnList),     % Verificar que la columna no esté llena (tiene al menos un 0)
    find_lowest_empty_row(ColumnList, RowIndex),
    replace_at_index_custom(ColumnList, RowIndex, Piece, UpdatedColumn),
    replace_column(Board, Column, UpdatedColumn, NewBoard).
    
    
% da el índice de la posición más baja disponible
find_lowest_empty_row(ColumnList, RowIndex) :-
    % Función para encontrar el índice del último cero desde abajo
    find_last_zero_index(ColumnList, 0, RowIndex).

% da el índice del último cero
find_last_zero_index([], _, -1).
find_last_zero_index([0|Rest], CurrentIndex, LastZeroIndex) :-
    NextIndex is CurrentIndex + 1,
    find_last_zero_index(Rest, NextIndex, PrevLastZeroIndex),
    (PrevLastZeroIndex = -1 -> LastZeroIndex = CurrentIndex 
                             ;  LastZeroIndex = PrevLastZeroIndex).
find_last_zero_index([_|Rest], CurrentIndex, LastZeroIndex) :-
    NextIndex is CurrentIndex + 1,
    find_last_zero_index(Rest, NextIndex, LastZeroIndex).

% Reemplazar un elemento en un índice específico de una lista
replace_at_index_custom(List, Index, NewElement, NewList) :-
    replace_at_index_aux(List, Index, NewElement, NewList, 0).

% Función auxiliar de reemplazo recursivo
replace_at_index_aux([], _, _, [], _).
replace_at_index_aux([_|Rest], Index, NewElement, [NewElement|Rest], Index) :- !.
replace_at_index_aux([Head|Rest], Index, NewElement, [Head|NewRest], CurrentIndex) :-
    NextIndex is CurrentIndex + 1,
    replace_at_index_aux(Rest, Index, NewElement, NewRest, NextIndex).


% get_column(Board, ColumnNum, ListColumn)
get_column(Board, ColumnNum, Column) :-
    between(1, 7, ColumnNum),
    findall(Element,(mymember(Row, Board),
    get_element_at(Row, ColumnNum, Element)), Column).

% replace_column(Board, ColumnNum, NewColumn, NewBoard)
replace_column(Board, ColumnNum, NewColumn, NewBoard) :-
    replace_column(Board, ColumnNum, NewColumn, NewBoard, 1).


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
last_at_list([_|Rest], Last) :- 
    last_at_list(Rest, Last).

% rest_at_list: Obtiene el resto de la lista sin el primer elemento
rest_at_list([_|Rest], Rest).

mylenght( [], 0 ).
mylenght( [_|Tail], Lenght) :-
	mylenght( Tail, LenghtAcum ),
	Lenght is LenghtAcum + 1.



