:-include('aulinhas.pl').

run:-
		anoEscolar(2,
								[
									[[1,2], [3,5], [1,5], [2,3], [1,4]],
									[[1,3], [4,2], [5,1], [2,3], [4,2]]
								],
								5, 10, 2).

anoEscolar(NumTurmas, Horarios, NumDisciplinas, NumSemanas, MaxTPC):-
		NumDisciplinas =< 7, %todo
		length(Turmas, NumTurmas),
		arranjaTurma(Horarios, NumDisciplinas, NumSemanas, Turmas, MaxTPC),
		%verificaTestesProximos(Turmas, NumDisciplinas),
		imprimeTurmas(Turmas, Horarios, 1).

arranjaTurma([], _, _, [],_).
arranjaTurma([Horario | RestantesTurmas], NumDisciplinas, NumSemanas, [[Testes, TPC] | Resto], MaxTPC):-
		verificarDias(Horario, NumDisciplinas),
		verificaTestesAno(NumSemanas, NumDisciplinas, Horario, Testes), !,
		verificarTPC(NumSemanas, Horario, NumDisciplinas, MaxTPC, TPC), !,
		arranjaTurma(RestantesTurmas, NumDisciplinas, NumSemanas, Resto, MaxTPC).

verificaTurmaA2(Turma1, Turma2, Teste, NumDisciplinas):-
		Teste =< NumDisciplinas,
		nth0(T1, Turma1, Teste),
		nth0(T2, Turma2, Teste),
		T1 >= T2,
		Ti is (0 - T2),
		sum([T1, Ti], =<, 10),
		TesteSeguinte is (Teste + 1),
		verificaTurmaA2(Turma1, Turma2, TesteSeguinte, NumDisciplinas).
verificaTurmaA2(Turma1, Turma2, Teste, NumDisciplinas):-
		Teste =< NumDisciplinas,
		nth0(T1, Turma1, Teste),
		nth0(T2, Turma2, Teste),
		T1 < T2,
		Ti is (0 - T1),
		sum([Ti, T2], =<, 10),
		TesteSeguinte is (Teste + 1),
		verificaTurmaA2(Turma1, Turma2, TesteSeguinte, NumDisciplinas).
verificaTurmaA2(_,_,_,_).


verificaTestesProximos([[TestesTurma1, _] | [[TestesTurma2, _] | Resto]], NumDisciplinas):-
		verificaTurmaA2(TestesTurma1, TestesTurma2, 1, NumDisciplinas),
		verificaTestesProximos([[TestesTurma2, _] | Resto], NumDisciplinas).
