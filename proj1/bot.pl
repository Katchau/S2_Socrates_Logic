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

jump_bot_cycle(Board, NewBoard, Piece, X, Y, Xf, Yf, Num):- Num is 0,
																											 			jump_bot_cycle_aux(Board, NewBoard, Piece, X, Y, Xf, Yf, Num).

jump_bot_cycle_aux(Board, NewBoard, Piece, X, Y, Xf, Yf, Num):- (
																																		jump(Board, NextBoard, Piece, X, Y, Xf, Yf, Xd, Yd),
																																		can_reJump(NextBoard, Piece, Xd, Yd),
																																		Num1 is Num+1,
																																		nl, display_board(NextBoard), nl,
																																		repeat ,
																																		(
																																				get_random_ortho(Xd, Yd, Xnew, Ynew),
																																				jump_bot_cycle_aux(NextBoard, NewBoard, Piece, Xd, Yd, Xnew, Ynew, Num1)
																																		),
																																		nl, display_board(NewBoard), nl
																																);
																																Num is Num1+1,
																																jump(Board, NewBoard, Piece, X, Y, Xf, Yf).

bot_movement_aux(Board, NewBoard, Piece, X, Y, Xf, Yf, Num):- Num is 0,
																															bot_movement_aux2(Board, NewBoard, Piece, X, Y, Xf, Yf, Num).

bot_movement_aux2(Board, NewBoard, Piece, X, Y, Xf, Yf, Num):- validate_destination(X, Y, Xf, Yf),
                                                         (
                                                         			jump_bot_cycle(Board, NewBoard, Piece, X, Y, Xf, Yf, Num);
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


verify_bot_movement(Board, NewBoard, Piece, X, Y):- Xf is X + 1, Yf is Y, bot_movement_aux(Board, NewBoard, Piece, X, Y, Xf, Yf, _).
verify_bot_movement(Board, NewBoard, Piece, X, Y):- Xf is X - 1, Yf is Y, bot_movement_aux(Board, NewBoard, Piece, X, Y, Xf, Yf, _).
verify_bot_movement(Board, NewBoard, Piece, X, Y):- Xf is X, Yf is Y + 1, bot_movement_aux(Board, NewBoard, Piece, X, Y, Xf, Yf, _).
verify_bot_movement(Board, NewBoard, Piece, X, Y):- Xf is X, Yf is Y - 1, bot_movement_aux(Board, NewBoard, Piece, X, Y, Xf, Yf, _).

random_cycle(Board, NewBoard, Piece, X, Y):- repeat,
																						 (
																						 			get_random_dest(X, Y, Xf, Yf),
																									bot_movement_aux(Board, NewBoard, Piece, X, Y, Xf, Yf, _)
																						 ).

%aqui
hard_mode(Board, NewBoard, Piece):- Num is 0,
																		hard_cycle(Board, NewBoard, Piece, X, Y, Xf, Yf, Num, Xx, Yy),
																		move_piece(Board, NewBoard, Xx, Yy, Xf, Yf, Piece).

hard_cycle(Board, NewBoard, Piece, X, Y, Xf, Yf, Num, Xx, Yy):- Xi is 1,	Yi is 1,
																																(
																																		X < 10,
																																		hard_cycle_aux(Board, NewBoard, Piece, X, Y, Xff, Yff, N, 0),
																																		X1 is X+1,
																																		(
																																				N >= Num,
																																				hard_cycle(Board, NewBoard, Piece, X1, Y, Xff, Yff, N, Xx, Yy);
																																				hard_cycle(Board, NewBoard, Piece, X1, Y, Xf, Yf, Num, Xx, Yy)
																																		)
																					 				 							);
																																(
																																			Y < 10,
																																			hard_cycle_aux(Board, NewBoard, Piece, X, Y, Xff, Yff, N, 0),
																																			Y1 is Y+1,
																																			(
																																						N >= Num,
																																						hard_cycle(Board, NewBoard, Piece, X, Y1, Xff, Yff, N, Xx, Yy);
																																						hard_cycle(Board, NewBoard, Piece, X, Y1, Xf, Yf, Num, Xx, Yy)
																																			)
																																)

hard_cycle_aux(Board, NewBoard, Piece, X, Y, Xf, Yf, N, R):- get_random_coord(X, Y, Xff, Yff, R),
																														 bot_movement_aux(Board, NewBoard, Piece, X, Y, Xff, Yff, Num),
																														 (
																																	Num >= N,
																																	R1 is R+1,
																																	hard_cycle_aux(Board, NewBoard, Piece, X, Y, Xff, Yff, Num, R1);
																																	R1 is R+1,
																																	hard_cycle_aux(Board, NewBoard, Piece, X, Y, Xf, Yf, Num, R1)
																														 )

choose_random_ini_movement(Board, NewBoard, Piece, X, Y):- verify_bot_movement(Board, NewBoard, Piece, X, Y).



choose_random_movement(Board, NewBoard, Piece, Plays):- length(Plays, Num), N is Num - 1, N >= 1, random(0, N, Random),
														nth0(Random, Plays, Vect), nth0(0, Vect, X), nth0(1, Vect, Y),
														random_cycle(Board, NewBoard, Piece, X, Y).

choose_random_movement(Board, NewBoard, Piece, Plays):- nth0(0, Plays, Vect), nth0(0, Vect, X), nth0(1, Vect, Y),
														random_cycle(Board, NewBoard, Piece, X, Y).


bot_play(Board, NewBoard, Plays, Piece, N_turn):-  choose_random_movement(Board, NewBoard, Piece, Plays).
											%repeat,
											%(
											%	get_random_initial(Board, Piece, X, Y),
											%	choose_random_ini_movement(Board, NewBoard, Piece, X, Y)
											%).
