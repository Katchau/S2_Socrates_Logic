:-include('bot.pl').

verify_movement_aux(Board, Piece, X, Y, Xf, Yf):- select_piece(Board, X, Y, Elem), Elem == Piece,
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


verify_movement2(Board, Piece, X, Y):- Xf is X + 1, Yf is Y, verify_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_movement2(Board, Piece, X, Y):- Xf is X - 1, Yf is Y, verify_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_movement2(Board, Piece, X, Y):- Xf is X, Yf is Y + 1, verify_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_movement2(Board, Piece, X, Y):- Xf is X, Yf is Y - 1, verify_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_movement2(Board, Piece, X, Y):- Xf is X + 1, Yf is Y - 1, verify_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_movement2(Board, Piece, X, Y):- Xf is X - 1, Yf is Y - 1, verify_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_movement2(Board, Piece, X, Y):- Xf is X + 1, Yf is Y + 1, verify_movement_aux(Board, Piece, X, Y, Xf, Yf).
verify_movement2(Board, Piece, X, Y):- Xf is X - 1, Yf is Y + 1, verify_movement_aux(Board, Piece, X, Y, Xf, Yf).

next_possible_step(Board, B_s, Piece, PP, X , Y):-	(
																	X < B_s,
																	Xn is X + 1,
																	nextPossiblePlay_aux(Board, B_s, Piece,  PP, Xn , Y)
																);
																(
																	Y < B_s,
																	Xn is 1,
																	Yn is Y + 1,
																	nextPossiblePlay_aux(Board, B_s, Piece, PP, Xn , Yn)
																).

nextPossiblePlay_aux(_, B_s, _, _, X, Y):- X == B_s, Y == B_s .
nextPossiblePlay_aux(Board, B_s, Piece, [L1 | Ls], X , Y):-	(
																	verify_movement2(Board, Piece, X, Y),
																	array_push(L1, X, Y),
																	next_possible_step(Board, B_s, Piece, Ls, X , Y)
																);
 																next_possible_step(Board, B_s, Piece, [L1 | Ls], X , Y).


% PP = possible plays
nextPossiblePlays(Board, Piece, PP):- X is 1, Y is 1, length(Board, B_s),
                                     nextPossiblePlay_aux(Board, B_s, Piece, PP, X, Y), !.	   

determine_player(Num, x):- Num == 0 .
determine_player(Num, o):- Num \== 0 .

empty(X) :-
    (nonvar(X), empty(X, _)), !
    ;
    empty(X, _).

verify_no_play(Plays):- nth0(0, Plays, Ele), length(Ele, L), L \== 2, !.

initGamePVB():- load_lib,
                final_board(Board),
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
