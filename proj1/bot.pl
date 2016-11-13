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
														
get_random_initial(Board, Piece, X, Y):- random(0, 4, Number) , length(Board, N), Boardsize is N - 1, get_random_ini_coord(Board, Boardsize, Piece, Number, X, Y), !.


get_random_coord(X, Y, Xf, Yf, N):- N == 0, Xf is X, Yf is Y - 1.
get_random_coord(X, Y, Xf, Yf, N):- N == 1, Xf is X, Yf is Y + 1.
get_random_coord(X, Y, Xf, Yf, N):- N == 2, Xf is X - 1, Yf is Y.
get_random_coord(X, Y, Xf, Yf, N):- N == 3, Xf is X + 1, Yf is Y.
get_random_coord(X, Y, Xf, Yf, N):- N == 4, Xf is X + 1, Yf is Y - 1 .
get_random_coord(X, Y, Xf, Yf, N):- N == 5, Xf is X - 1, Yf is Y - 1 .
get_random_coord(X, Y, Xf, Yf, N):- N == 6, Xf is X + 1, Yf is Y + 1 .
get_random_coord(X, Y, Xf, Yf, N):- N == 7, Xf is X - 1, Yf is Y + 1 .

get_random_ortho(X, Y, Xf, Yf):- random(0, 4, Numb), get_random_coord(X, Y, Xf, Yf, Numb), !.
get_random_dest(X, Y, Xf, Yf):- random(0, 8, Numb), get_random_coord(X, Y, Xf, Yf, Numb), !.

jump_bot_cycle(Board, NewBoard, Piece, X, Y, Xf, Yf):- (
															jump(Board, NextBoard, Piece, X, Y, Xf, Yf, Xd, Yd),
															can_reJump(NextBoard, Piece, Xd, Yd),
															nl, display_board(NextBoard), nl,
															repeat , 
															(
																get_random_ortho(Xd, Yd, Xnew, Ynew),
																jump_cycle(NextBoard, NewBoard, Piece, Xd, Yd, Xnew, Ynew)
															),
															nl, display_board(NewBoard), nl
														); 
														jump(Board, NewBoard, Piece, X, Y, Xf, Yf).


bot_movement_aux(Board, NewBoard, Piece, X, Y, Xf, Yf):- validate_destination(X, Y, Xf, Yf),
                                                            (
                                                               jump_bot_cycle(Board, NewBoard, Piece, X, Y, Xf, Yf);
                                                               (
																   replace_element(Board, CleanBoard, X, Y, v) ,check_ortho_adjacency(CleanBoard, Piece, Xf, Yf),
                                                                   check_restriction(Board, X, Y, Xf, Yf),
                                                                   (
                                                                      length(Board, Boardsize), check_center_move(Boardsize, X, Y, Xf, Yf);
                                                                      check_mov_adjoining(Board, Xf, Yf)
                                                                   ),
																   move_piece(Board, NewBoard, X, Y, Xf, Yf, Piece)
                                                               )
                                                            ).

verify_bot_movement_aux(Board, Piece, X, Y, Xf, Yf):- select_piece(Board, X, Y, Elem), Elem == Piece,
                                                      (
                                                         jump(Board, _, Piece, X, Y, Xf, Yf);
                                                         (
															   replace_element(Board, CleanBoard, X, Y, v) ,check_ortho_adjacency(CleanBoard, Piece, Xf, Yf),
                                                             check_restriction(Board, X, Y, Xf, Yf),
                                                             (
                                                                length(Board, Boardsize), check_center_move(Boardsize, X, Y, Xf, Yf);
                                                                check_mov_adjoining(Board, Xf, Yf)
                                                             )
                                                         )
                                                      ).

															
verify_bot_movement(Board, NewBoard, Piece, X, Y):- Xf is X + 1, Yf is Y, bot_movement_aux(Board, NewBoard, Piece, X, Y, Xf, Yf).
verify_bot_movement(Board, NewBoard, Piece, X, Y):- Xf is X - 1, Yf is Y, bot_movement_aux(Board, NewBoard, Piece, X, Y, Xf, Yf).
verify_bot_movement(Board, NewBoard, Piece, X, Y):- Xf is X, Yf is Y + 1, bot_movement_aux(Board, NewBoard, Piece, X, Y, Xf, Yf).
verify_bot_movement(Board, NewBoard, Piece, X, Y):- Xf is X, Yf is Y - 1, bot_movement_aux(Board, NewBoard, Piece, X, Y, Xf, Yf).


verify_bot_movement2(Board, Piece, X, Y):- Xf is X + 1, Yf is Y, verify_bot_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_bot_movement2(Board, Piece, X, Y):- Xf is X - 1, Yf is Y, verify_bot_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_bot_movement2(Board, Piece, X, Y):- Xf is X, Yf is Y + 1, verify_bot_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_bot_movement2(Board, Piece, X, Y):- Xf is X, Yf is Y - 1, verify_bot_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_bot_movement2(Board, Piece, X, Y):- Xf is X + 1, Yf is Y - 1, verify_bot_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_bot_movement2(Board, Piece, X, Y):- Xf is X - 1, Yf is Y - 1, verify_bot_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_bot_movement2(Board, Piece, X, Y):- Xf is X + 1, Yf is Y + 1, verify_bot_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_bot_movement2(Board, Piece, X, Y):- Xf is X - 1, Yf is Y + 1, verify_bot_movement_aux(Board, Piece, X, Y, Xf, Yf).

array_push([X , Y], X, Y).

% PP = possible plays
botPossiblePlays(Board, Piece, PP):- X is 1, Y is 1, length(Board, B_s),
                                     botPossiblePlay_aux(Board, B_s, Piece, PP, X, Y), !.

next_possible_step(Board, B_s, Piece, PP, X , Y):-	(
																	X < B_s,
																	Xn is X + 1,
																	botPossiblePlay_aux(Board, B_s, Piece,  PP, Xn , Y)
																);
																(
																	Y < B_s,
																	Xn is 1,
																	Yn is Y + 1,
																	botPossiblePlay_aux(Board, B_s, Piece, PP, Xn , Yn)
																).

botPossiblePlay_aux(_, B_s, _, _, X, Y):- X == B_s, Y == B_s .
botPossiblePlay_aux(Board, B_s, Piece, [L1 | Ls], X , Y):-	(
																	verify_bot_movement2(Board, Piece, X, Y),
																	array_push(L1, X, Y),
																	next_possible_step(Board, B_s, Piece, Ls, X , Y)
																);
 																next_possible_step(Board, B_s, Piece, [L1 | Ls], X , Y).




																		

choose_random_ini_movement(Board, NewBoard, Piece, X, Y):- verify_bot_movement(Board, NewBoard, Piece, X, Y).

choose_random_movement(Board, NewBoard, Piece, Plays):- length(Plays, Num), N is Num - 1, random(0, N, Random),
														nth0(Random, Plays, Vect), nth0(0, Vect, X), nth0(1, Vect, Y),
														repeat,
														(
															get_random_dest(X, Y, Xf, Yf),
															bot_movement_aux(Board, NewBoard, Piece, X, Y, Xf, Yf)
														).

bot_play(Board, NewBoard, Piece, N_turn):-  botPossiblePlays(Board, Piece, Plays), choose_random_movement(Board, NewBoard, Piece, Plays).
											%repeat,
											%(
											%	get_random_initial(Board, Piece, X, Y),
											%	choose_random_ini_movement(Board, NewBoard, Piece, X, Y)
											%).
												