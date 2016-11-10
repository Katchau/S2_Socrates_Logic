:-include('board.pl').

verifyPlayerPiece(Pnum, Piece):- Piece == 'x', Pnum == 0; Piece == 'o', Pnum == 1.

checkRightPiece(Board, X, Y, Pnum, Piece):- select_piece(Board, X, Y, Piece),
                                            verifyPlayerPiece(Pnum, Piece).

initGamePVP():- load_lib, board(Board),
                playGamePVPinit(Board).

playGamePVPinit(Board):- N is 0,
                         playGamePVP(N, Board).

playGamePVP(N, Board):- N1 is N+1,
                        Num is (N mod 2), Pnum is (Num + 1), nl,
                        write('Player'), write(Pnum), write(' playing:'), nl,
                        display_board(Board), nl,
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
                            (
                                jump(Board, Piece, X, Y, Xf, Yf);
                                (
                                    check_restriction(Board, X, Y, Xf, Yf),
                                    (
                                        check_center_move(10, X, Y, Xf, Yf)
                                        %replace_element_board(Board, NewBoard, X, Y, Xf, Yf, 0, Peca)
                                    )
                                )
                            )
                        ),
                        playGamePVP(N1, newBoard).
