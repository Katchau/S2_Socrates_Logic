:-include('board.pl').

verifyPossiblePlay(Board, Piece, Pnum):- X is 1, Y is 1, Xf is 1, Yf is 1,
                                         verifyPossiblePlay_aux(Board, Piece, Pnum, X, Y, Xf, Yf), !.

verifyPossiblePlay_aux(Board, Piece, Pnum, X, Y, Xf, Yf):- checkRightPiece(Board, X, Y, Pnum, Piece),
                                                           verifyPossiblePlay_aux2(Board, Piece, Pnum, X, Y, Xf, Yf);
                                                           Xn is (X+1),
                                                           Xn =< 10,
                                                           verifyPossiblePlay_aux(Board, Piece, Pnum, Xn, Y, Xf, Yf);
                                                           Yn is Y+1,
                                                           Yn =< 10,
                                                           verifyPossiblePlay_aux(Board, Piece, Pnum, X, Yn, Xf, Yf).

verifyPossiblePlay_aux2(Board, Piece, Pnum, X, Y, Xf, Yf):- validate_destination(X, Y, Xf, Yf),
                                                            (
                                                               jump(Board, _, Piece, X, Y, Xf, Yf);
                                                               (
                                                                   check_restriction(Board, X, Y, Xf, Yf),
                                                                   (
                                                                      check_center_move(10, X, Y, Xf, Yf);
                                                                      check_mov_adjoining(Board, Xf, Yf)
                                                                   )
                                                               )
                                                            );
                                                            Xfn is (Xf+1),
                                                            Xfn =< 10,
                                                            verifyPossiblePlay_aux2(Board, Piece, Pnum, X, Y, Xfn, Yf);
                                                            Yfn is Yf+1,
                                                            Yfn =< 10,
                                                            verifyPossiblePlay_aux2(Board, Piece, Pnum, X, Y, Xf, Yfn).



verifyPlayerPiece(Pnum, Piece):- Piece == 'x', Pnum == 0; Piece == 'o', Pnum == 1.

checkRightPiece(Board, X, Y, Pnum, Piece):- select_piece(Board, X, Y, Piece),
                                            verifyPlayerPiece(Pnum, Piece).

initGamePVP():- load_lib,
                board(Board),
                playGamePVPinit(Board).

playGamePVPinit(Board):- N is 0,
                         playGamePVP(N, Board).

playGamePVP(N, Board):- N1 is N+1,
                        Num is (N mod 2), Pnum is (Num + 1), nl,
                        write('Player'), write(Pnum), write(' playing:'), nl,
                        display_board(Board), nl,
                        (
                            not(verifyPossiblePlay(Board, Piece, Num)),
                            NewBoard = Board,
                            write('Impossible Movement'), nl;
                            (
                                repeat,
                                (
                                    repeat,
                                    (
                                        write('Enter the coordinates of the piece:'), nl,
                                        readCoords(X,Y),
                                        checkRightPiece(Board, X, Y, Num, Piece)
                                    ),
                                    write('Enter the coordinates of the destinantion of the piece:'), nl,
                                    readCoords(Xf,Yf),
							                      validate_destination(X, Y, Xf, Yf),
                                    (
                                        jump(Board, NewBoard, Piece, X, Y, Xf, Yf);
                                        (
                                            check_restriction(Board, X, Y, Xf, Yf),
                                            (
                                                (
                                                    check_center_move(10, X, Y, Xf, Yf);
                                                    check_mov_adjoining(Board, Xf, Yf)
                                                ),
                                                move_piece(Board, NewBoard, X, Y, Xf, Yf, Piece)
                                            )
                                        )
                                    )
                                )
                            )
                        ),
						            (
                            game_over(Piece, NewBoard, Pnum);
                            playGamePVP(N1, NewBoard)
                        ).
