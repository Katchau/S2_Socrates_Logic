:- use_module(library(lists)).


imprimeTestes([]).
imprimeTestes([Segunda, Terca, Quarta, Quinta, Sexta | Resto]):-
    format("Segunda:~w Terca:~w Quarta:~w Quinta:~w Sexta:~w ~n",[Segunda, Terca, Quarta, Quinta, Sexta]),
    imprimeTestes(Resto).
	
imprimeTPC([]).
imprimeTPC([[Segunda, Terca, Quarta, Quinta, Sexta] | Resto]):-
    format("Segunda:~w Terca:~w Quarta:~w Quinta:~w Sexta:~w ~n",[Segunda, Terca, Quarta, Quinta, Sexta]),
    imprimeTPC(Resto).