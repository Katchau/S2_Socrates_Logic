%Todos os patinhos sabem bem nadar 
%Sabem bem nadar 
%Cabeça para baixo, rabinho para o ar 
%Cabeça para baixo, rabinho para o ar 
%
%Quando estão cansados da água vão sair 
%Da água vão sair 
%Depois em grande fila, para o ninho querem ir 
%Depois em grande fila, para o ninho querem ir
load_lib:- use_module(library(clpfd)), use_module(library(lists)).

inicializarDia(Dia, N):-
	Length in 0..N,
	length(Dia, Length),
	domain(Dia, 1, N),
	all_distinct(Dia),
	labeling([],[Length]),
	labeling([], Dia).
	
exp(A,B,C):-
	domain([A,B,C],1,3), X in 2..5,
	count(1,[A,B,C],#=,X), labeling([],[X]).

unirDias([], []).
unirDias([Dia | Ndias], Juncao):-
	unirDias(Dia, D1),
    unirDias(Ndias, D2),
    append(D1, D2, Juncao),
	!.
unirDias(D, [D]). 

verificarAulas(_, NDisciplinas, Disc):-
NDisciplinas == Disc.
verificarAulas(Total, NDisciplinas, Disc):-
	NDisciplinas \= Disc,
	count(Disc, Total, #>=, 1),
	count(Disc, Total, #=<, 4),
	Disc2 is Disc + 1,
	verificarAulas(Total, NDisciplinas, Disc2).

verificarDias(Horario, NDisciplinas):-
	unirDias(Horario, Total),
	nvalue(NDisciplinas, Total),
	verificarAulas(Total, NDisciplinas, 1).
	
