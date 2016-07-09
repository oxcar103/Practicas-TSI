horarios(Pedro, Juana, Ana, Yago, David, Maria, Mhorario) :-
member(Pedro, [3,4,5,6]),
member(Juana, [3,4]),
member(Ana, [2,3,4,5]),
member(Yago, [2,3,4]),
member(David, [3,4]),
member(Maria, [1,2,3,4,5,6]),

Pedro=\=Juana,
Pedro=\=Ana,
Pedro=\=Yago,
Pedro=\=David,
Pedro=\=Maria,
Juana=\=Ana,
Juana=\=Yago,
Juana=\=David,
Juana=\=Maria,
Ana=\=Yago,
Ana=\=David,
Ana=\=Maria,
Yago=\=David,
Yago=\=Maria,
David=\=Maria,
Mhorario is Juana + Ana + Maria.

ismin(_,[]).
ismin(X,[Y|Tail]):-X=<Y,ismin(X,Tail).

antes(Pedro,Juana,Ana,Yago,David,Maria,Mhorario) :-
findall(Mhorario1, horarios(Pedro,Juana,Ana,Yago,David,Maria,Mhorario1),L), horarios(Pedro,Juana,Ana,Yago,David,Maria,Mhorario), ismin(Mhorario,L),!.