:-include('bot.pl').

initGamePVB():- load_lib,
                board(Board),
                playGamePVBinit(Board).

playGamePVBinit(Board):- N is 0,
						 length(Board, Boardsize), 
                         playGamePVB(N, Board, Boardsize).

playGamePVB(N, Board, Boardsize):- N1 is N+1,
                        Num is (N mod 2), Pnum is (Num + 1), nl,
                        write('Player'), write(Pnum), write(' playing:'), nl,
                        display_board(Board), nl,
						determine_player(Num, Piece), 
						nextPossiblePlays(Board, Piece, Plays),
                        (
 
							verify_no_play(Plays),
                            NewBoard = Board,
                            write('Impossible Movement'), nl;
                            (
								Num == 0,
								player_play(Board, NewBoard, Boardsize, Num, Piece)
							);
							(
								Num \== 0,
								bot_play(Board, NewBoard, Plays, Piece, N)
							)
                        ),
						(
                            game_over(Piece, NewBoard, Pnum);
                            playGamePVB(N1, NewBoard, Boardsize)
                        ).
