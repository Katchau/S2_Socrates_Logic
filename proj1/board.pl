board([	
			[x,o,x,o,x,o,x,o,x,o],	
			[o,x,o,x,o,x,o,x,o,x],	
			[x,o,x,o,x,o,x,o,x,o],	
			[o,x,o,x,o,x,o,x,o,x],	
			[x,o,x,o,x,o,x,o,x,o],	
			[o,x,o,x,o,x,o,x,o,x],	
			[x,o,x,o,x,o,x,o,x,o],	
			[o,x,o,x,o,x,o,x,o,x],	
			[x,o,x,o,x,o,x,o,x,o], 
			[o,x,o,x,o,x,o,x,o,x]
		]).
		
initial_board([	
			[x,o,x,o,x,o,x,o,x,o],	
			[o,x,o,x,o,x,o,x,o,x],	
			[x,o,x,o,x,o,x,o,x,o],	
			[o,x,o,x,o,x,o,x,o,x],	
			[x,o,x,o,x,o,x,o,x,o],	
			[o,x,o,x,o,x,o,x,o,x],	
			[x,o,x,o,x,o,x,o,x,o],	
			[o,x,o,x,o,x,o,x,o,x],	
			[x,o,x,o,x,o,x,o,x,o], 
			[o,x,o,x,o,x,o,x,o,x]
		]).

final_board([	
			[x,v,v,v,v,v,v,v,x,v],	
			[v,x,v,v,v,v,v,x,v,x],	
			[v,v,v,v,v,v,v,v,v,v],	
			[v,v,v,v,v,v,v,v,v,v],	
			[x,v,v,v,v,v,v,v,v,x],	
			[v,x,v,v,v,x,v,v,v,v],	
			[v,v,v,v,v,v,v,v,v,v],	
			[v,v,v,x,v,v,v,v,v,v],	
			[v,v,v,v,v,v,x,v,x,v], 
			[v,x,v,v,v,v,v,x,v,v]
		]).
		
middle_board([	
			[x,v,x,v,v,o,v,v,x,o],	
			[v,v,v,v,v,v,v,x,o,x],	
			[v,v,v,v,v,o,x,v,v,v],	
			[v,v,v,v,v,x,v,v,v,x],	
			[x,v,v,v,v,o,v,v,v,v],	
			[v,x,v,v,v,x,o,x,o,x],	
			[x,v,v,v,v,o,x,o,x,o],	
			[v,v,v,v,o,v,v,x,o,x],	
			[v,v,v,v,v,v,v,o,v,v], 
			[o,v,o,v,v,v,v,x,o,x]
		]).
		
display_final_line(N):- write('   1   2   3   4   5   6   7   8   9  10 ').
display_number_line(N) :- write(N).
display_division() :- write('  ---------------------------------------').

display_board_aux([], N) :- display_division(), nl , display_final_line(N).
display_board_aux([L1 | Ls] , N) :- N1 is N+1,  display_division(), nl, display_line(L1), 
								  display_number_line(N1), nl, display_board_aux(Ls, N1).
display_board([L1 | Ls]) :- display_board_aux([L1 | Ls], 0).

display_line([]):- write(' |') .
display_line([E1 | Es]) :-  write(' |'), traduz(E1),  display_line(Es).


traduz(v) :- write('  ').
traduz(o) :- write(' O').
traduz(x) :- write(' X'). 


perc_choice([L1 | Ls], N, L) :- N == L -> display_line(L1);  perc_board(Ls, N, L).
perc_board([L1 | Ls], N, L) :- L2 is L + 1 ,  perc_choice([L1 | Ls], N, L2).

display_specific_line([L1 | Ls], N) :- perc_board([L1 | Ls], N, 0 ).

destroy_end([L1 | Ls], X, X1):- X == X1 -> traduz(L1) ; destroy_ex(Ls , X, X1).
destroy_ex([L1 | Ls], X, X1):- X2 is X1 + 1, destroy_end([L1 | Ls], X, X2).
destroy_line([L1 | Ls], X, Y, X1, Y1) :- Y == Y1 -> destroy_ex(L1, X, X1);  destroy_rec(Ls , X, Y, X1, Y1).
destroy_rec([L1 | Ls], X, Y, X1, Y1):- Y2 is Y1 + 1, destroy_line([L1 | Ls], X, Y, X1, Y2).
destroy_peca([L1 | Ls], X, Y):- destroy_rec([L1 | Ls], X, Y, 0, 0).



