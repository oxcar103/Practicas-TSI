	miembro(X, [X|_]).
	miembro(X, [ _ | Tail]) :- miembro(X,Tail).


top:-
	miembro(X,[1,2,3,4]),
	writeln(X),
	fail.

top:-
	writeln("Todos los valores seleccionados.")
