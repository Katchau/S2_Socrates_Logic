:-include('bot.pl').

initGameBVB():- load_lib,
                board(Board),
                nl, write('Player v CPU mode'), nl,
                playGameBVBinit(Board).

playGameBVBinit(Board):- N is 0,
						 length(Board, Boardsize),
                         playGameBVB(N, Board, Boardsize).

playGameBVB(N, Board, Boardsize):- N1 is N+1,
                        Num is (N mod 2), Pnum is (Num + 1), nl,
                        write('Bot'), write(Pnum), write(' playing:'), nl,
                        display_board(Board), nl,
						determine_player(Num, Piece),
						nextPossiblePlays(Board, Piece, Plays),
                        (

							verify_no_play(Plays),
                            NewBoard = Board,
                            write('Impossible Movement'), nl;
							bot_play(Board, NewBoard, Plays, Piece, N)
                        ),
						(
                            game_over(Piece, NewBoard, Pnum), 
							nl, write(N1), write("Plays were made");
                            playGameBVB(N1, NewBoard, Boardsize)
                        ).
