:- use_module(library(lists)).

traduzDisciplina(1,'Portugues     ').
traduzDisciplina(2,'Matematica    ').
traduzDisciplina(3,'Ciencias      ').
traduzDisciplina(4,'Fisico-Quimica').
traduzDisciplina(5,'Desenho       ').
traduzDisciplina(6,'Historia      ').
traduzDisciplina(7,'Memeologia    ').
traduzDisciplina(0,'              ').

traduzDisciplinaH(1,'Portugues').
traduzDisciplinaH(2,'Matematica').
traduzDisciplinaH(3,'Ciencias').
traduzDisciplinaH(4,'Fisico-Quimica').
traduzDisciplinaH(5,'Desenho').
traduzDisciplinaH(6,'Historia').
traduzDisciplinaH(7,'Memeologia').

traduzDiaSemana(1,'Segunda').
traduzDiaSemana(2,'Terca  ').
traduzDiaSemana(3,'Quarta ').
traduzDiaSemana(4,'Quinta ').
traduzDiaSemana(5,'Sexta  ').


imprimeTurmaHorario(Horario):-
    write('Horario:'),nl,
    imprimeHorario(Horario, 1),
    write('').

imprimeHorario([],_).
imprimeHorario([Dia | Resto], DiaS):-
    traduzDiaSemana(DiaS, DiaSemana),
    format(" ~w:", [DiaSemana]),
    imprimeDia(Dia),
    DiaSeguinte is DiaS + 1,
    imprimeHorario(Resto, DiaSeguinte).

imprimeDia([Disciplina]):-
    traduzDisciplinaH(Disciplina, Disc),
    format(" ~w ~n", [Disc]).
imprimeDia([Disciplina | Resto]):-
    traduzDisciplinaH(Disciplina, Disc),
    format(" ~w,", [Disc]),
    imprimeDia(Resto).

imprimeCalendarioTestes(CalendarioTestes):-
    write(' ___________________________________________________Testes:_________________________________________________________ '), nl,
    imprimeTestes(CalendarioTestes),
    write(' ___________________________________________________________________________________________________________________ ').

imprimeTestes([]).
imprimeTestes([Segunda, Terca, Quarta, Quinta, Sexta | Resto]):-
    traduzDisciplina(Segunda, Seg),
    traduzDisciplina(Terca, Ter),
    traduzDisciplina(Quarta, Qua),
    traduzDisciplina(Quinta, Qui),
    traduzDisciplina(Sexta, Sex),
    format("| Segunda: ~w Terca: ~w Quarta: ~w Quinta: ~w Sexta: ~w |~n",[Seg, Ter, Qua, Qui, Sex]),
    imprimeTestes(Resto).

imprimeCalendarioTPC(CalendarioTPC):-
    write(' TPC:'), nl,
    imprimeTPC(CalendarioTPC).

imprimeTPC([]).
imprimeTPC([[Segunda, Terca, Quarta, Quinta, Sexta] | Resto]):-
    write(' Segunda:'),
    imprimeTPCDia(Segunda),
    write(' Terca:'),
    imprimeTPCDia(Terca),
    write(' Quarta:'),
    imprimeTPCDia(Quarta),
    write(' Quinta:'),
    imprimeTPCDia(Quinta),
    write(' Sexta:'),
    imprimeTPCDia(Sexta),nl,
    imprimeTPC(Resto).

imprimeTPCDia([Disciplina]):-
    traduzDisciplinaH(Disciplina, Disc),
    format(" ~w    ", [Disc]).
imprimeTPCDia([Disciplina | Resto]):-
    traduzDisciplinaH(Disciplina, Disc),
    format(" ~w,", [Disc]),
    imprimeTPCDia(Resto).
