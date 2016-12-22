:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).

somaNnumeros(Start, End, Soma):-
	Start >= End,
	Soma is Start.
somaNnumeros(Start, End, Soma):- 
		Start \= End,
		Next = Start + 1,
		somaNnumeros(Next, End, Soma1),
		Soma is Soma1 + Start.

criaCalendario(NumSemanas, Calendario):-
    NumDias is (NumSemanas * 5),
    length(Calendario, NumDias).

verificaTestesAno(NumSemanas, Disciplinas, Horario):-
    length(Disciplinas, NumDisciplinas),
		NumTestes is (NumDisciplinas * 2),
    criaCalendario(NumSemanas, Calendario),
    length(Calendario, NumDias),
    domain(Disciplinas,0,2),
    domain(Calendario,0,NumDisciplinas),
		sum(Disciplinas, #=, NumTestes),
    NumDiasSemTeste is (NumDias - NumTestes),
    count(0, Calendario, #=, NumDiasSemTeste),
		divisaoDosTestes(Calendario, TestesInt, TestesFin),
		verificaTestesDiferentes(TestesInt, NumDisciplinas, 1),
    verificaTestesTodasSemanas(TestesInt, Horario),
    verificaTestesDiferentes(TestesFin, NumDisciplinas, 1),
		verificaTestesTodasSemanas(TestesFin, Horario),
    labeling([], Calendario),
    imprimeCalendario(Calendario),
    labeling([], Disciplinas).

divisaoDosTestes(Calendario, TestesInt, TestesFin):-
		length(Calendario, Tam),
		T is div(Tam, 5),
		Tamanho is div(T, 2),
		TFin is Tamanho * 5,
		sublist(Calendario, TestesFin,TFin,_,0),
		TInt is Tam - TFin,
		sublist(Calendario, TestesInt,0,_,TInt).

verificaTestesDiferentes(Calendario, NumTestes, Teste):-
    Teste =< NumTestes,
    count(Teste, Calendario, #=, 1),
    TesteSeguinte is Teste + 1,
    verificaTestesDiferentes(Calendario, NumTestes, TesteSeguinte).
verificaTestesDiferentes(_,_,_).

verificaTestesTodasSemanas([], _).
verificaTestesTodasSemanas([Dia1, Dia2, Dia3, Dia4, Dia5  | Resto], Horario):-
    verificaTestesMesmaSemana([Dia1, Dia2, Dia3, Dia4, Dia5]),
		verificaDisciplinasNoDia([Dia1, Dia2, Dia3, Dia4, Dia5], Horario),
    verificaTestesTodasSemanas(Resto, Horario).

verificaDisciplinasNoDia([],[]).
verificaDisciplinasNoDia([Teste | Outros], [Dia | Resto]):-
		append(Dia, [0], Ver),
		Teste #= Var,
		member(Var, Ver),
		verificaDisciplinasNoDia(Outros, Resto).

verificaTestesMesmaSemana(Dias):-
    count(0, Dias, #>= ,3),
    verfificaTestesDiasConsecutivos(Dias).

verfificaTestesDiasConsecutivos([_]).
verfificaTestesDiasConsecutivos([Dia1 | [Dia2 | Resto]]):-
    count(0,[Dia1, Dia2], #>=, 1),
    verfificaTestesDiasConsecutivos([Dia2 | Resto]).


unirDias([], []).
unirDias([Dia | Ndias], Juncao):-
	unirDias(Dia, D1),
    unirDias(Ndias, D2),
    append(D1, D2, Juncao),
	!.
unirDias(D, [D]).

verificarAulas(_, NDisciplinas, Disc):-
NDisciplinas < Disc.
verificarAulas(Total, NDisciplinas, Disc):-
	NDisciplinas >= Disc,
	count(Disc, Total, #>=, 1), %1 a 4 aulas por semana 1 cadeira
	count(Disc, Total, #=<, 4),
	Disc2 is Disc + 1,
	verificarAulas(Total, NDisciplinas, Disc2).

verificarDias(Horario, NDisciplinas):-
	unirDias(Horario, Total),
	nvalue(NDisciplinas, Total),
	verificarAulas(Total, NDisciplinas, 1).

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

totalAulasCadeira([],_,Soma):- Soma is 0.
totalAulasCadeira([Dia1 | Resto], Cadeira, Soma):-
	member(Cadeira, Dia1),
	totalAulasCadeira(Resto, Cadeira, Soma1),
	Soma is Soma1 + 1.
totalAulasCadeira([Dia1 | Resto], Cadeira, Soma):-
	\+ member(Cadeira, Dia1),
	totalAulasCadeira(Resto, Cadeira, Soma1),
	Soma is Soma1 + 0.
totalCadeiras(_, _, NCadeiras, CurC, []):-
	NCadeiras < CurC .
totalCadeiras(NumSemanas, Horario, NCadeiras, CurC, [T1 | Tr]):-
	NCadeiras >= CurC,
	totalAulasCadeira(Horario, CurC, Tmp),
	Tmp2 is Tmp * NumSemanas * 0.5 ,
	T1 is round(Tmp2),
	NexC is CurC + 1,
	totalCadeiras(NumSemanas, Horario, NCadeiras, NexC, Tr),!.


% verificarTPCD([],[]).
% verificarTPCD([Dia | Resto], [TPCd | TPCr]):-
	% length(Dia, Length),%ter outro array com pushs da posicao dos 1, dp fazer um count para ver quantos é que tem, sendo esse count limitado
	% length(TPCd, Length),
	% domain(TPCd, 0, 1),
	% count(1,TPCd,#=<,2),% max 2 tpc diario
	% sum(TPCd,#=,Max),
	% labeling([maximize(Max)], TPCd),
	% verificarTPCD(Resto, TPCr).

tpcCadeira([],[],[]).
tpcCadeira([_ | Cr], [Tt | Tr], [Tt | Resto]):-
	Tt == 0,
	tpcCadeira(Cr, Tr, Resto).
tpcCadeira([C1 | Cr], [Tt | Tr], [C1 | Resto]):-
	Tt == 1,
	tpcCadeira(Cr, Tr, Resto).
	
	
%tpc diario
verificarTPCD([],[]).
verificarTPCD([Dia | Resto], [TPCd | TPCr]):-
	length(Dia, Length),%ter outro array com pushs da posicao dos 1, dp fazer um count para ver quantos é que tem, sendo esse count limitado
	length(Tmp, Length),
	domain(Tmp, 0, 1),
	count(1,Tmp,#=<,2),% max 2 tpc diario
	sum(Tmp,#=,Max),
	labeling([], Tmp), %ta aqui o problema xD
	tpcCadeira(Dia, Tmp, TPCd),
	verificarTPCD(Resto, TPCr).

cleanDay(Day, Length):-
	length(Day, Length),
	maplist(=(0), Day).% wow

removeDayOff([], [], _, _).
removeDayOff([Old | Or], [New | Nr], Day, CurD):-
	Day == CurD,
	length(Old, Length),
	cleanDay(New,Length),
	NexD is CurD + 1,
	removeDayOff(Or, Nr, Day, NexD).
removeDayOff([Old | Or], [Old | Nr], Day, CurD):-
	Day \= CurD,
	NexD is CurD + 1,
	removeDayOff(Or, Nr, Day, NexD).

%tpc semanal
verificarTPCS(NumSemanas , _, _, [], NSemana):- NumSemanas =< NSemana.
verificarTPCS(NumSemanas, Horario, NoClass, [TPC1 | Resto], NSemana):-
	NumSemanas > NSemana,
	verificarTPCD(Horario, Tmp1),
	removeDayOff(Tmp1, TPC1, NoClass, 0),
	NextS is NSemana + 1,
	verificarTPCS(NumSemanas, Horario, NoClass, Resto, NextS).

verificarTotalTPC(_, _, []).
verificarTotalTPC(CurC, Tpc, [T1 | Tr]):-
	count(CurC,Tpc,#=<,T1),
	NexC is CurC + 1,
	verificarTotalTPC(NexC, Tpc, Tr).
	
verificarTPC(NumSemanas, Horario, NCadeiras, TPC):-
	totalCadeiras(NumSemanas, Horario, NCadeiras, 1, TotalC),!,
	random(0, 5, NoClass),
	verificarTPCS(NumSemanas, Horario, NoClass, TPC, 0),
	unirDias(TPC, Juncao),
	verificarTotalTPC(1, Juncao, TotalC).

imprimeCalendario([]).
imprimeCalendario([Segunda, Terca, Quarta, Quinta, Sexta | Resto]):-
    format("Segunda:~w Terca:~w Quarta:~w Quinta:~w Sexta:~w ~n",[Segunda, Terca, Quarta, Quinta, Sexta]),
    imprimeCalendario(Resto).
