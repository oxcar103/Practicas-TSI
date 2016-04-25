valor(1).
valor(2).
valor(3).
valor(4).


asignaValor(X):-
  valor(X),
  write("Valor: "),write(X),nl,
  fail.
asignaValor(X):-
  write("Asignados todos los valores."),nl.

top:-
  asignaValor(X).
