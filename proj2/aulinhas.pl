:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(samsort)).
:-include('calendario.pl').

% anoEscolar(Horario, NumSemanas, NumDisciplinas):-
	% verificaTestesAno(NumSemanas, NumDisciplinas, )


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

verificarAulasRepetidas([]).
verificarAulasRepetidas([Dia | Resto]):-
	all_distinct(Dia),
	verificarAulasRepetidas(Resto).

verificarDias(Horario, NDisciplinas):-
	unirDias(Horario, Total),
	verificarAulasRepetidas(Horario),
	nvalue(NDisciplinas, Total),
	verificarAulas(Total, NDisciplinas, 1).

criarDia(_, [], DS):- DS == 6 . %fim de semana. que bom
criarDia(Disciplinas, [Dia | Resto], DS):-
	DS \= 6,
	length(Dia, Disciplinas),
	domain(Dia, 0, Disciplinas),
	all_distinct(Dia),
	Prox is DS+ 1,
	labeling([down, all], Dia),
	criarDia(Disciplinas, Resto, Prox).

contagemNumeros(_, [], _).
contagemNumeros(Dia, [O | Or],CurC):-
	count(CurC, Dia, #=<, O),
	NexC is CurC + 1,
	contagemNumeros(Dia, Or, NexC).
	
	
inicializarDias(_, [], _,_).
inicializarDias(NDis, [Dia | Prox],NumCadeiras, CurC):-
	length(Dia, NDis),
	domain(Dia, 0, NDis),
	all_distinct(Dia),
	append(CurC, Dia, New),
	contagemNumeros(New, NumCadeiras, 1),
	labeling([down, all], Dia),
	inicializarDias(NDis, Prox, NumCadeiras, New).

criarHorario2(Disciplinas, Horario):-
	length(Horario,5), % 5 dias da semana
	length(NumCadeiras, Disciplinas),
	domain(NumCadeiras, 1, 4),
	labeling([down, all], NumCadeiras),
	inicializarDias(Disciplinas, Horario, NumCadeiras, []).

deleteZeros([],[]).
deleteZeros([L1 | Ls], [R1 | Rs]):-
 	delete(L1, 0, R1),
 	deleteZeros(Ls, Rs).

%ainda em protótipo. Dp tem de se dar uns randomzitos
criarHorario(Disciplinas, Horario):-
	criarDia(Disciplinas, Temp, 1),
	deleteZeros(Temp, Horario),
	verificarDias(Horario, Disciplinas).


criaCalendario(NumSemanas, Calendario):-
    NumDias is (NumSemanas * 5),
    length(Calendario, NumDias).

verificaTestesAno(NumSemanas, NumDisciplinas, Horario, Calendario):-
	NumTestes is (NumDisciplinas * 2),
    criaCalendario(NumSemanas, Calendario),
    length(Calendario, NumDias),
    domain(Calendario,0,NumDisciplinas),
    NumDiasSemTeste is (NumDias - NumTestes),
    count(0, Calendario, #=, NumDiasSemTeste),
	divisaoDosTestes(Calendario, NumDisciplinas, TestesInt, TestesFin),
	verificaTestesDiferentes(TestesInt, NumDisciplinas, 1),
    verificaTestesTodasSemanas(TestesInt, Horario),
    verificaTestesDiferentes(TestesFin, NumDisciplinas, 1),
	verificaTestesTodasSemanas(TestesFin, Horario),
    labeling([middle, down], Calendario).
    %imprimeCalendarioTestes(Calendario).
	
	
divisaoDosTestes(Calendario, NTestes, TestesInt, TestesFin):-
	length(Calendario, Tam),
	T is div(Tam, 5),
	Tamanho is div(T, 2),
	TFin is Tamanho * 5,
	sublist(Calendario, TestesFin,TFin,_,0),
	TInt is Tam - TFin,
	sublist(Calendario, TestesInt,0,_,TInt),
	Tmp1 is NTestes * 0.5,
	TTestF is round(Tmp1) * 5,
	sublist(TestesFin, TestF,0,_,TTestF),
	sum(TestF,#=,0),
	Tmp2 is NTestes * 0.5,
	TTestI is round(Tmp2) * 5,
	sublist(TestesInt, TestI,0,_,TTestI),
	sum(TestI,#=,0).
	

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

comprimentoDias([], []).
comprimentoDias([D1 | Dr], [L | Ls]):-
	length(D1, L),
	comprimentoDias(Dr, Ls).

calcMediaDia([],_,[]).
calcMediaDia([0 | Dr], MediaTotal, [0 | Mr]):-
	calcMediaDia(Dr, MediaTotal, Mr).
calcMediaDia([D1 | Dr], MediaTotal,[M1 | Mr]):-
	nth1(D1, MediaTotal, M1),
	calcMediaDia(Dr, MediaTotal, Mr),!.

calcMedia([],_,[]).
calcMedia([D1 | Dr], MediaTotal, [M1 | Mr]):-
	calcMediaDia(D1, MediaTotal, Tmp),
	sumlist(Tmp, M1),
	calcMedia(Dr, MediaTotal, Mr),!.

verificarMembroDia(Horario, Dia, Elemento):-
	nth1(Dia, Horario, ArrayDia),
	member(Elemento, ArrayDia).
	
determinarDia(_, _, 69, Elems):-
	Elems > 1.
determinarDia(Horario, CurC, Dia, Elems):-
	Elems == 1,
	verificarMembroDia(Horario, Dia, CurC).

diasNaoRemoviveis(_,_, NCadeiras, [], CurC):-
		NCadeiras < CurC.
diasNaoRemoviveis(Horario, HorarioExp, NCadeiras, [C | Cs], CurC):-
		NCadeiras >= CurC,
		NexC is CurC + 1,
		findall(_,member(CurC, HorarioExp), Tmp),
		length(Tmp, Length),
		determinarDia(Horario, CurC, C, Length),
		diasNaoRemoviveis(Horario, HorarioExp, NCadeiras, Cs, NexC).

		
diaSemAulas(Horario, MediaTpc, NCadeiras, DiaOff):-
	comprimentoDias(Horario, Horario2),
	calcMedia(Horario, MediaTpc, HorarioM),
	unirDias(Horario, Juncao),
	diasNaoRemoviveis(Horario, Juncao, NCadeiras, CadeirasSoltas, 1),
	samsort(@=<,CadeirasSoltas, NaoRemover),!,
	length(Tmp1, 1),
	domain(Tmp1, 1, 5),
	element(1, Tmp1, DiaOff),
	element(DiaOff,NaoRemover,Elem),
	Elem #= 69, %69 indica que pode remover
	element(DiaOff, Horario2, Length),
	element(DiaOff, HorarioM, Media),
	Pontuacao #= Media * Length,
	labeling([minimize(Pontuacao)], Tmp1).

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

tpcCadeira([],[],[]).
tpcCadeira([_ | Cr], [Tt | Tr], [Tt | Resto]):-
	Tt == 0,
	tpcCadeira(Cr, Tr, Resto).
tpcCadeira([C1 | Cr], [Tt | Tr], [C1 | Resto]):-
	Tt == 1,
	tpcCadeira(Cr, Tr, Resto).


%tpc diario
verificarTPCD([],[], _).
verificarTPCD([Dia | Resto], [TPCd | TPCr], NMax):-
	length(Dia, Length),
	length(Tmp, Length),
	domain(Tmp, 0, 1),
	count(1,Tmp,#=<,NMax),% max 2 tpc diario
	sum(Dia,#=,Sum),
	sum(Tmp,#=<,Sum),
	labeling([down, all], Tmp), 
	tpcCadeira(Dia, Tmp, TPCd),
	verificarTPCD(Resto, TPCr, NMax).


updateMissingTPC([], _, [], _).
updateMissingTPC([L | Ls], Tpc, [N | Ns], CurC):-
	count(CurC, Tpc, #=<, L),
	findall(_, member(CurC, Tpc), Tmp),
	length(Tmp, Length),
	N is L - Length,
	NexC is CurC + 1,
	updateMissingTPC(Ls, Tpc, Ns, NexC).

%tpc semanal
verificarTPCS(NumSemanas, NSemana, _, _, _,[]):- NumSemanas =< NSemana.
verificarTPCS(NumSemanas, NSemana, Horario, ExpectTPC, TPCMax,[TPC1 | Resto]):-
	NumSemanas > NSemana,
	verificarTPCD(Horario, TPC1, TPCMax),
	unirDias(TPC1, Juncao),
	updateMissingTPC(ExpectTPC, Juncao, Update, 1),
	NextS is NSemana + 1,
	verificarTPCS(NumSemanas, NextS, Horario, Update, TPCMax,Resto).


verificarTPC(NumSemanas, Horario, NCadeiras, TPCMax):-
	totalCadeiras(NumSemanas, Horario, NCadeiras, 1, TotalC),!,
	diaSemAulas(Horario, TotalC, NCadeiras, DiaOff),
	removeDayOff(Horario, NewHorario, DiaOff, 1),
	verificarTPCS(NumSemanas, 0, NewHorario, TotalC, TPCMax, TPC),
	write(TPC). %todo
	%imprimeTPC(TPC).

