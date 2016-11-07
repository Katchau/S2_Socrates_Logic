:- include('usefull prepositions.pl').

check_ortho_aux(Board, X, Y, Peca):- X == 0; Y == 0; Y == 11; X == 1 .
check_ortho_aux(Board, X, Y, Peca):- select_piece(Board, X, Y, Other), Other \== Peca.
check_ortho_adjacency(Board, X, Y):- select_piece(Board, X, Y, Peca), Peca \== v, !, X1 is X + 1, X2 is X-1, Y1 is Y +1, Y2 is Y-1,
									 check_ortho_aux(Board, X1, Y, Peca), !, check_ortho_aux(Board, X, Y1, Peca), !,
									 check_ortho_aux(Board, X2, Y, Peca), !, check_ortho_aux(Board, X, Y2, Peca), !.


check_ortho_adv_aux(Board, X, Y, Peca):- select_piece(Board, X, Y, Other), Other \== Peca, Other \== v.

check_ortho_adv_adjacency(Peca, Board, X, Y):- select_piece(Board, X, Y, Peca), Peca \== v, !, X1 is X + 1, X2 is X-1, Y1 is Y +1, Y2 is Y-1,
									                      (
                                         check_ortho_adv_aux(Board, X1, Y, Peca), !;
                                         check_ortho_adv_aux(Board, X, Y1, Peca), !;
									                       check_ortho_adv_aux(Board, X2, Y, Peca), !;
                                         check_ortho_adv_aux(Board, X, Y2, Peca), !
                                        ).

check_ortho_adv_adjacency_dest(Peca, Board, X, Y):- select_piece(Board, X, Y, PecaDest), PecaDest == v, !, X1 is X + 1, X2 is X-1, Y1 is Y +1, Y2 is Y-1,
                                        (
                                         check_ortho_adv_aux(Board, X1, Y, Peca), !;
                                         check_ortho_adv_aux(Board, X, Y1, Peca), !;
                                         check_ortho_adv_aux(Board, X2, Y, Peca), !;
                                         check_ortho_adv_aux(Board, X, Y2, Peca), !
                                        ).

check_restriction(Board, X, Y, X1, X2) :- check_ortho_adv_adjacency(Peca, Board, X, Y), check_ortho_adv_adjacency_dest(Peca, Board, X1, X2), !; not(check_ortho_adv_adjacency(Peca, Board, X, Y)), Peca \== v.


replace_element_list([],[], X, X1, Peca).
replace_element_list([H | L1], [Peca | L2], X, X1, Peca):- X == X1, X2 is X1 + 1, !, replace_element_list(L1, L2, X, X2, Peca).
replace_element_list([H | L1], [H | L2], X, X1, Peca):- X \== X1 , X2 is X1 + 1, !, replace_element_list(L1, L2, X, X2, Peca).

replace_element_board([],[], X, Y, Y1, Peca).
replace_element_board([L | Ls], [L1 | Ls1], X, Y, Y1, Peca):- Y == Y1, Y2 is Y1 + 2, replace_element_list(L,L1,X,1,Peca), !, replace_element_board(Ls, Ls1, X, Y, Y2, Peca).
replace_element_board([L | Ls], [L | Ls1], X, Y, Y1, Peca):- Y \== Y1, Y2 is Y1 + 1, replace_element_board(Ls, Ls1, X, Y, Y2, Peca) ,!.


jump_aux(Board, Peca, X, Y):- X == 0; Y == 0; X == 11; Y == 11 .
jump_aux(Board, Peca, X, Y):- select_piece(Board, X, Y, Vazio), Vazio == v, !, replace_element_board(Board, Test, X, Y, 1, Peca),  !, check_ortho_adjacency(Test, X, Y).
jump_aux(Board, Peca, X0, Y0, X, Y):- X \== X0, Y0 == Y, X_F is X + (X-X0), !, jump_aux(Board, Peca, X_F, Y), !.
jump_aux(Board, Peca, X0, Y0, X, Y):- Y \== Y0, X0 == X, Y_F is Y + (Y-Y0), !, jump_aux(Board, Peca, X, Y_F), !.
jump(Board, Player, X0, Y0, X, Y):- select_piece(Board, X, Y, Peca), Peca \== Player, Peca \== v, !, jump_aux(Board, Player, X0, Y0, X, Y).
