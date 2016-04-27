dist2(hamburg, bremen, 80).
dist2(hamburg, berlin, 230).
dist2(bremen, dortmund, 200).
dist2(hannover, nuernberg, 380).
dist2(dortmund, koeln, 80).
dist2(kassel, frankfurt, 180).
dist2(nuernberg, muenchen, 160).
dist2(hamburg, hannover, 110).
dist2(bremen, hannover, 100).
dist2(hannover, kassel, 140).
dist2(dortmund, kassel, 130).
dist2(kassel, wuerzburg, 180).
dist2(frankfurt, wuerzburg, 110).

dist(X, Y, Km) :- dist2(X, Y, Km).
dist(X, Y, Km) :- dist2(Y, X, Km).

route(From, To, Km) :- dist(From, To, Km), print_list([From, To]).
route(From, To, Km) :- dist(From, City, Km2), City\=To, route(City, To, [From], Km3), Km is Km2 + Km3.

route(From, To, Route, Km) :- dist(From, To, Km), append(Route, [From, To], Ruta), print_list(Ruta).
route(From, To, Route, Km) :- dist(From, City, Km2), nonmember(City, Route), City\=To, append(Route, [From], Ruta), route(City, To, Ruta, Km3), Km is Km2 + Km3.

ismin(_,[]).
ismin(X,[Y|Tail]):-X=<Y,ismin(X,Tail).

shortestPath(From, To, Route, Km) :- findall(Km2,route(From,To,Route,Km2),L), route(From,To,Route,Km), ismin(Km,L), !.
