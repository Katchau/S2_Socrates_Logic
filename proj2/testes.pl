:- include('aulinhas.pl').

testaPrograma1:-
    run(2,
        [
          [[1,2,6], [3,5,7], [1,5], [2,3,5], [1,4,7]],
          [[1,3,7], [4,2,6], [5,1], [2,3,5], [4,2,7]]
        ],
        7, 12, 2, 1).

testaPrograma2:-
    run(6,
        [
          [[1,2,3],[2,3,4],[1,2],[3,2],[1,4]],
          [[1,2],[3,2],[1,4],[1,2,3,4],[2,3]],
          [[1,2,3],[2,3],[1,2,4],[3,2,4],[1,4]],
          [[1,2],[3,2],[1,4],[1,2,3],[2,3,4]],
          [[1,2,3],[2,3,4],[1,2],[3,2,4],[1,4]],
          [[1,2,4],[3,2],[1],[1,2,3,4],[2,3]]
        ],
        4, 12, 2, 2).

testaPrograma3:-
    run(2,
        [
          [[1,2,6], [3,5,7], [1,5], [2,3,5], [1,4,7]],
          [[1,3,7], [4,2,6], [5,1], [2,3,5], [4,2,7]]
        ],
        7, 12, 1, 3).

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
        4, 12, 1, 4).


testaPrograma5:-
    run(2,
        [
          [[1,2,6], [3,5,7], [1,5], [2,3,5], [1,4,7]],
          [[1,3,7], [4,2,6], [5,1], [2,3,5], [4,2,7]]
        ],
        7, 12, 2, 5).



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
        4, 12, 2, 6).

testaPrograma:-
    testaPrograma1,
    testaPrograma2,
    testaPrograma3,
    testaPrograma4,
    testaPrograma5,
    testaPrograma6.

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
		NumDisciplinas =< 7, %todo
		length(Turmas, NumTurmas),
		arranjaTurma(Horarios, NumDisciplinas, NumSemanas, Turmas, MaxTPC).

run(NumTurmas, Horarios, NumDisciplinas, NumSemanas, MaxTPC, Num):-
    statistics(runtime, [T0|_]),
    anoEscolarTeste(NumTurmas, Horarios, NumDisciplinas, NumSemanas, MaxTPC),
    statistics(runtime, [T1|_]),
    T is T1 - T0,
    format('~d: solve/3 took ~3d sec.~n', [Num, T]).
