:- use_module(library(clpfd)).
:- use_module(library(lists)).

criaCalendario(NumSemanas, Calendario):-
    NumDias is (NumSemanas * 5),
    length(Calendario, NumDias).

verificaTestesAno(NumSemanas, Disciplinas):-
    length(Disciplinas, NumTestes),
    criaCalendario(NumSemanas, Calendario),
    length(Calendario, NumDias),
    domain(Disciplinas,0,1),
    domain(Calendario,0,NumTestes),
    sum(Disciplinas, #=, NumTestes),
    NumDiasSemTeste is (NumDias - NumTestes),
    count(0, Calendario, #=, NumDiasSemTeste),
    verificaTestesTodasSemanas(Calendario),
    verificaTestesDiferentes(Calendario, NumTestes, 1),
    labeling([], Calendario),
    imprimeCalendario(Calendario),
    labeling([], Disciplinas).

verificaTestesDiferentes(Calendario, NumTestes, Teste):-
    Teste =< NumTestes,
    count(Teste, Calendario, #=, 1),
    TesteSeguinte is Teste + 1,
    verificaTestesDiferentes(Calendario, NumTestes, TesteSeguinte).
verificaTestesDiferentes(_,_,_).

verificaTestesTodasSemanas([]).
verificaTestesTodasSemanas([Dia1, Dia2, Dia3, Dia4, Dia5  | Resto]):-
    verificaTestesMesmaSemana([Dia1, Dia2, Dia3, Dia4, Dia5]),
    verificaTestesTodasSemanas(Resto).

verificaTestesMesmaSemana(Dias):-
    count(0, Dias, #>= ,3),
    verfificaTestesDiasConsecutivos(Dias).

verfificaTestesDiasConsecutivos([_]).
verfificaTestesDiasConsecutivos([Dia1 | [Dia2 | Resto]]):-
    count(0,[Dia1, Dia2], #>=, 1),
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
