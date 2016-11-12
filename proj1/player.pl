:-include('board.pl').

verifyPlayerPiece(Pnum, Piece):- Piece == 'x', Pnum == 0; Piece == 'o', Pnum == 1.

checkRightPiece(Board, X, Y, Pnum, Piece):- select_piece(Board, X, Y, Piece),
                                            verifyPlayerPiece(Pnum, Piece).

											
first_read(Board, Boardsize, Piece, X, Y, Num):- repeat,
									  (
										  write('Enter the coordinates of the piece:'), nl,
										  readCoords(X,Y, Boardsize),
										  checkRightPiece(Board, X, Y, Num, Piece)
									  ).

destination_read(Boardsize, X, Y, Xf, Yf):- write('Enter the coordinates of the destinantion of the piece:'), nl,
											readCoords(Xf,Yf, Boardsize),
											validate_destination(X, Y, Xf, Yf).
								  
player_play(Board, NewBoard, Boardsize, Num, Piece):-  repeat,
											(	
												 first_read(Board, Boardsize, Piece, X, Y, Num),
												 destination_read(Boardsize, X, Y, Xf, Yf),
												 (
													 jump_cycle(Board, NewBoard, Piece, X, Y, Xf, Yf);
													 (
														 replace_element(Board, CleanBoard, X, Y, v) ,check_ortho_adjacency(CleanBoard, Piece, Xf, Yf), 
														 check_restriction(Board, X, Y, Xf, Yf), 
														 (
															 (
																 check_center_move(Boardsize, X, Y, Xf, Yf);
																 check_mov_adjoining(Board, Xf, Yf)
															 ),
															 move_piece(Board, NewBoard, X, Y, Xf, Yf, Piece)
														 )
													 )
												 )
											).
			   