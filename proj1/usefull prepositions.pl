load_lib:- use_module(library(lists)).

get_vector(X0, Y0, X , Y, Xf, Yf):- Xf is X - X0, Yf is Y - Y0 .

readCoords(X,Y):- write('X= '), read(XX),
				  ((XX > 10 ; XX < 1) -> X = 1; X = XX),
				  nl, write('Y= '), read(YY),
				  ((YY > 10 ; YY < 1) -> Y = 1; Y = YY).
				  
replace_element_list([],[], X, X1, Peca).
replace_element_list([H | L1], [Peca | L2], X, X1, Peca):- X == X1, X2 is X1 + 1, !, replace_element_list(L1, L2, X, X2, Peca).
replace_element_list([H | L1], [H | L2], X, X1, Peca):- X \== X1 , X2 is X1 + 1, !, replace_element_list(L1, L2, X, X2, Peca).

replace_element_board([],[], X, Y, Y1, Peca).
replace_element_board([L | Ls], [L1 | Ls1], X, Y, Y1, Peca):- Y == Y1, Y2 is Y1 + 2, replace_element_list(L,L1,X,1,Peca), !, replace_element_board(Ls, Ls1, X, Y, Y2, Peca).
replace_element_board([L | Ls], [L | Ls1], X, Y, Y1, Peca):- Y \== Y1, Y2 is Y1 + 1, replace_element_board(Ls, Ls1, X, Y, Y2, Peca) ,!.
