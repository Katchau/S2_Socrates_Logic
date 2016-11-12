:-include('bot.pl').

verifyPossiblePlay(Board, Boardsize, Piece, Pnum):- X is 1, Y is 1, Xf is 1, Yf is 1,
                                         verifyPossiblePlay_aux(Board, Boardsize, Piece, Pnum, X, Y, Xf, Yf), !.

verifyPossiblePlay_aux(Board, Boardsize, Piece, Pnum, X, Y, Xf, Yf):- checkRightPiece(Board, X, Y, Pnum, Piece),
                                                           verifyPossiblePlay_aux2(Board, Boardsize, Piece, Pnum, X, Y, Xf, Yf);
                                                           Xn is (X+1),
                                                           Xn =< 10,
                                                           verifyPossiblePlay_aux(Board, Boardsize, Piece, Pnum, Xn, Y, Xf, Yf);
                                                           Yn is Y+1,
                                                           Yn =< 10,
                                                           verifyPossiblePlay_aux(Board, Boardsize, Piece, Pnum, X, Yn, Xf, Yf).

verifyPossiblePlay_aux2(Board, Boardsize, Piece, Pnum, X, Y, Xf, Yf):- validate_destination(X, Y, Xf, Yf),
                                                            (
                                                               jump(Board, _, Piece, X, Y, Xf, Yf);
                                                               (
																   replace_element(Board, CleanBoard, X, Y, v) ,check_ortho_adjacency(CleanBoard, Piece, Xf, Yf),
                                                                   check_restriction(Board, X, Y, Xf, Yf),
                                                                   (
                                                                      check_center_move(Boardsize, X, Y, Xf, Yf);
                                                                      check_mov_adjoining(Board, Xf, Yf)
                                                                   )
                                                               )
                                                            );
                                                            Xfn is (Xf+1),
                                                            Xfn =< 10,
                                                            verifyPossiblePlay_aux2(Board, Boardsize, Piece, Pnum, X, Y, Xfn, Yf);
                                                            Yfn is Yf+1,
                                                            Yfn =< 10,
                                                            verifyPossiblePlay_aux2(Board, Boardsize, Piece, Pnum, X, Y, Xf, Yfn).


			   

initGamePVP():- load_lib,
                board(Board),
                playGamePVPinit(Board).

playGamePVPinit(Board):- N is 0,
						 length(Board, Boardsize), 
                         playGamePVP(N, Board, Boardsize).

playGamePVP(N, Board, Boardsize):- N1 is N+1,
                        Num is (N mod 2), Pnum is (Num + 1), nl,
                        write('Player'), write(Pnum), write(' playing:'), nl,
                        display_board(Board), nl,
                        (
                            not(verifyPossiblePlay(Board, Boardsize, Piece, Num)),
                            NewBoard = Board,
                            write('Impossible Movement'), nl;
                            (
								Num == 0,
								player_play(Board, NewBoard, Boardsize, Num, Piece)
							);
							(
								Num \== 0,
								bot_play(Board, Piece, N),
								NewBoard = Board
							)
                        ),
						(
                            game_over(Piece, NewBoard, Pnum);
                            playGamePVP(N1, NewBoard, Boardsize)
                        ).
