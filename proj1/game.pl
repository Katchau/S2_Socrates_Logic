:- include('board.pl').

start_game([L1 | Ls], Player).
available_movement([L1 | Ls], Player, X1, Y1, X2, Y2).
available_jump([L1 | Ls], Player,  X1, Y1, X2, Y2).
skip_turn([L1 | Ls] ,Player).
concede_game([L1 | Ls] , Player).

initGamePVP():- load_lib, board(Board), display_board(Board).

check_piece_existence(Piece, [X | Xs]):- member(Piece, X) ; check_piece_existence(Piece, Xs).
game_over(Player, Board):- load_lib,not(check_piece_existence(Player, Board)), write("Fim de jogo").

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
