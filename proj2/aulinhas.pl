:- use_module(library(clpfd)).
:- use_module(library(lists)).

somaNnumeros(Start, End, Soma):-
	Start >= End,
	Soma is Start, !.
somaNnumeros(Start, End, Soma):- !,
		Start \= End,
		Next = Start + 1,
		somaNnumeros(Next, End, Soma1),
		Soma is Soma1 + Start, !. 

criaCalendario(NumSemanas, Calendario):-
    NumDias is (NumSemanas * 5),
    length(Calendario, NumDias).

criarDia(_, [], DS):- DS == 6 . %fim de semana. que bom
criarDia(Disciplinas, [Dia | Resto], DS):-
	DS \= 6,
	length(Dia, Disciplinas),
	domain(Dia, 0, Disciplinas),
	all_distinct(Dia),
	Prox is DS+ 1,
	labeling([], Dia),
	criarDia(Disciplinas, Resto, Prox).

deleteZeros([],[]).
deleteZeros([L1 | Ls], [R1 | Rs]):-
	delete(L1, 0, R1),
	deleteZeros(Ls, Rs).

%ainda em protótipo. Dp tem de se dar uns randomzitos
criarHorario(Disciplinas, Horario):-
		criarDia(Disciplinas, Temp, 1),
		deleteZeros(Temp, Horario),
		verificarDias(Horario, Disciplinas).
	
verificaTestesAno(NumSemanas, Disciplinas):-
    criaCalendario(NumSemanas, Calendario),
    domain(Disciplinas,0,2),
    domain(Calendario,0,1),
    length(Disciplinas, Tamanho),
    NumTestes is (Tamanho * 2),
    sum(Disciplinas, #=, NumTestes),
    sum(Calendario, #=, NumTestes),
    verificaTestesTodasSemanas(Calendario),
    labeling([], Calendario),
    imprimeCalendario(Calendario),
    labeling([], Disciplinas).

verificaTestesTodasSemanas([]).
verificaTestesTodasSemanas([Dia1, Dia2, Dia3, Dia4, Dia5  | Resto]):-
    verificaTestesMesmaSemana([Dia1, Dia2, Dia3, Dia4, Dia5]),
    verificaTestesTodasSemanas(Resto).

verificaTestesMesmaSemana(Dias):-
    sum(Dias, #=< ,2),
    verfificaTestesDiasConsecutivos(Dias).

verfificaTestesDiasConsecutivos([]).
verfificaTestesDiasConsecutivos([Dia]):-
    Dia #=< 1.
verfificaTestesDiasConsecutivos([Dia1 | [Dia2 | Resto]]):-
    Dia1 + Dia2 #=< 1,
    verfificaTestesDiasConsecutivos([Dia2 | Resto]).

verificaTPCNoDia([],_,_).
verificaTPCNoDia([Dia | Resto], N, DiaLivre):-
    N =:= DiaLivre,
    Dia #= 0,
    N1 is (N + 1),
    verificaTPCNoDia(Resto, N1, DiaLivre).
verificaTPCNoDia([Dia | Resto], N, DiaLivre):-
    Dia #=< 2,
    N1 is (N + 1),
    verificaTPCNoDia(Resto, N1, DiaLivre).

verificaTPCMesmaSemana(Dias):-
    domain(Dias,0,2),
    verificaTPCNoDia(Dias, 1, 3),
    labeling([], Dias).

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
	count(Disc, Total, #>=, 1), %1 a 4 aulas por semana 1 cadeira
	count(Disc, Total, #=<, 4),
	Disc2 is Disc + 1,
	verificarAulas(Total, NDisciplinas, Disc2).

verificarDias(Horario, NDisciplinas):-
	unirDias(Horario, Total),
	nvalue(NDisciplinas, Total),
	verificarAulas(Total, NDisciplinas, 1).	

imprimeCalendario([]).
imprimeCalendario([Segunda, Terca, Quarta, Quinta, Sexta | Resto]):-
    format("Segunda:~w Terca:~w Quarta:~w Quinta:~w Sexta:~w ~n",[Segunda, Terca, Quarta, Quinta, Sexta]),
    imprimeCalendario(Resto).
