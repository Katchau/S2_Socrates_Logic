:-include('player.pl').

get_random_ini_coord(Board, _, Piece, Number, X, Y):- Number == 0, Y is 1, nth0(0, Board, Line), get_random_index(Line, Piece, X).
get_random_ini_coord(Board, Boardsize, Piece, Number, X, Y):- Number == 1, Y is Boardsize + 1, nth0(Boardsize, Board, Line), get_random_index(Line, Piece, X).

get_random_ini_coord(Board, Boardsize, Piece, Number, X, Y):-  Number == 2, X is 1, N is Boardsize + 1,
														repeat, 
														(
															random(0, N, Y1),
															Y is Y1 + 1,
															select_piece(Board, X, Y, Element),
															Element == Piece
														).
														
get_random_ini_coord(Board, Boardsize, Piece, Number, X, Y):-  Number == 3, N is Boardsize + 1, X is N,
														repeat, 
														(
															random(0, N, Y1),
															Y is Y1 + 1,
															select_piece(Board, X, Y, Element),
															Element == Piece
														).
														
get_random_initial(Board, Piece, X, Y):- random(0, 4, Number), length(Board, N), Boardsize is N - 1, get_random_ini_coord(Board, Boardsize, Piece, Number, X, Y), !.






bot_play(Board, Piece, N_turn):- get_random_initial(Board, Piece, X, Y).