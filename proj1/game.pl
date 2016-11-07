:- include('board.pl').

start_game([L1 | Ls], Player).
available_movement([L1 | Ls], Player, X1, Y1, X2, Y2).
available_jump([L1 | Ls], Player,  X1, Y1, X2, Y2).
skip_turn([L1 | Ls] ,Player).
concede_game([L1 | Ls] , Player).

initGamePVP():- load_lib, board(Board), display_board(Board).

check_piece_existence(Piece, [X | Xs]):- member(Piece, X) ; check_piece_existence(Piece, Xs).
game_over(Player, Board):- load_lib,not(check_piece_existence(Player, Board)), write("Fim de jogo").

