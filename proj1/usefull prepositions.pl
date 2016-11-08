load_lib:- use_module(library(lists)).

get_vector(X0, Y0, X , Y, Xf, Yf):- Xf is X - X0, Yf is Y - Y0 .

readCoords(X,Y):- write('X= '), read(XX),
				  ((XX > 10 ; XX < 1) -> X = 1; X = XX),
				  nl, write('Y= '), read(YY),
				  ((YY > 10 ; YY < 1) -> Y = 1; Y = YY).