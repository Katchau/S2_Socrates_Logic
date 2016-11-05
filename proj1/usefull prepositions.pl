append([],L,L).
append([X|L1],L2,[X|L3]):- append(L1,L2,L3).

member(X, [X | Xs]).
member(X, [Y|Ys]):- member(X, Ys).
prefix([], Ys).
prefix([X | Xs], [X | Ys]):- prefix(Xs, Ys).
suffix(Xs, Xs).
suffix(Xs, [Y | Ys]):- suffix(Xs, Ys).
sublist(Xs,Ys):- prefix(Ps, Ys), suffix(Xs, Ps).
sublist(Xs, Ys):- prefix(Xs, Ss), suffix(Ss, Ys).
reverse(Xs, Ys):- reverse(Xs, [], Ys).
reverse([X|Xs], Acc, Ys):- reverse(Xs, [X|Acc], Ys).
reverse([], Ys, Ys).
length([], 0).
length([X|Xs], N):- N1 is N-1, length(Xs, N1).
delete([X|Xs], X, Ys):- delete(Xs, X, Ys).
delete([X|Xs], Z, [X|Ys]):- X=\=Z, delete(Xs, Z, Ys).
delete([], X, []).
select(X, [X|Xs], Xs).
select(X,[Y|Ys], [Y | Zs]):- select(X, Ys, Zs). 
