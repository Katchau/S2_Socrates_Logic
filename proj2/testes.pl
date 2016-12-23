:- include('aulinhas.pl').

testaPrograma1:-
    run(2,
        [
          [[1,2,3],[2,3,4],[1,2],[3,2],[1,4]],
          [[1,2],[3,2],[1,4],[1,2,3,4],[2,3]]
        ],
        4, 10, 2, 1).

testaPrograma4:-
    run(6,
        [
          [[1,2,3],[2,3,4],[1,2],[3,2],[1,4]],
          [[1,2],[3,2],[1,4],[1,2,3,4],[2,3]],
          [[1,2,3],[2,3],[1,2,4],[3,2,4],[1,4]],
          [[1,2],[3,2],[1,4],[1,2,3],[2,3,4]],
          [[1,2,3],[2,3,4],[1,2],[3,2,4],[1,4]],
          [[1,2,4],[3,2],[1],[1,2,3,4],[2,3]]
        ],
        4, 10, 2, 4).

testaPrograma2:-
    run(2,
        [
          [[1,2,3],[2,3],[1,2,4],[3,2,4],[1,4]],
          [[1,2],[3,2],[1,4],[1,2,3],[2,3,4]]
        ],
        4, 25, 1, 2).

testaPrograma5:-
    run(6,
        [
          [[1,2,3],[2,3,4],[1,2],[3,2],[1,4]],
          [[1,2],[3,2],[1,4],[1,2,3,4],[2,3]],
          [[1,2,3],[2,3],[1,2,4],[3,2,4],[1,4]],
          [[1,2],[3,2],[1,4],[1,2,3],[2,3,4]],
          [[1,2,3],[2,3,4],[1,2],[3,2,4],[1,4]],
          [[1,2,4],[3,2],[1],[1,2,3,4],[2,3]]
        ],
        4, 25, 1, 5).


testaPrograma3:-
    run(2,
        [
          [[1,2,3],[2,3,4],[1,2],[3,2,4],[1,4]],
          [[1,2,4],[3,2],[1],[1,2,3,4],[2,3]]
        ],
        4, 50, 2, 3).



testaPrograma6:-
    run(6,
        [
          [[1,2,3],[2,3,4],[1,2],[3,2],[1,4]],
          [[1,2],[3,2],[1,4],[1,2,3,4],[2,3]],
          [[1,2,3],[2,3],[1,2,4],[3,2,4],[1,4]],
          [[1,2],[3,2],[1,4],[1,2,3],[2,3,4]],
          [[1,2,3],[2,3,4],[1,2],[3,2,4],[1,4]],
          [[1,2,4],[3,2],[1],[1,2,3,4],[2,3]]
        ],
        4, 50, 2, 6).

testaPrograma7:-
    run(2,
        [
          [[1], [2], [1], [2], [1]],
          [[2], [1], [2], [1], [2]]
        ],
        2, 50, 2, 2).

testaPrograma8:-
    run(2,
        [
          [[1,2,3],[2,3,4],[1,2],[3,2],[1,4]],
          [[1,2],[3,2],[1,4],[1,2,3,4],[2,3]]
        ],
        4, 10, 2, 4).

testaPrograma9:-
    run(2,
        [
          [[1,2,6], [3,5,7], [1,5], [2,3,5], [1,4,7]],
          [[1,3,7], [4,2,6], [5,1], [2,3,5], [4,2,7]]
        ],
        7, 50, 2, 7).



testaProgramaTurmasESemanas:-
    testaPrograma1,
    testaPrograma2,
    testaPrograma3,
    testaPrograma4,
    testaPrograma5,
    testaPrograma6.

testaProgramaDisciplinas:-
    testaPrograma7,
    testaPrograma8,
    testaPrograma9.

run:-
  anoEscolar(
  6,
      [
        [[1,2,3],[2,3,4],[1,2],[3,2],[1,4]],
        [[1,2],[3,2],[1,4],[1,2,3,4],[2,3]],
        [[1,2,3],[2,3],[1,2,4],[3,2,4],[1,4]],
        [[1,2],[3,2],[1,4],[1,2,3],[2,3,4]],
        [[1,2,3],[2,3,4],[1,2],[3,2,4],[1,4]],
        [[1,2,4],[3,2],[1],[1,2,3,4],[2,3]]
      ],
      4, 12, 2).

anoEscolarTeste(NumTurmas, Horarios, NumDisciplinas, NumSemanas, MaxTPC):-
		NumDisciplinas =< 7,
		length(Turmas, NumTurmas),
		arranjaTurma(Horarios, NumDisciplinas, NumSemanas, Turmas, MaxTPC).

run(NumTurmas, Horarios, NumDisciplinas, NumSemanas, MaxTPC, Num):-
    statistics(runtime, [T0|_]),
    anoEscolarTeste(NumTurmas, Horarios, NumDisciplinas, NumSemanas, MaxTPC),
    statistics(runtime, [T1|_]),
    T is T1 - T0,
    format('~d: anoEscolar took ~3d sec.~n', [Num, T]).
