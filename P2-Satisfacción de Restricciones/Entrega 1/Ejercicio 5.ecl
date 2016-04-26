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

route(From, To) :- dist(From, To, _), append([], [From], Route), append(Route, [To], Ruta), print_list(Ruta).
route(From, To) :- dist(From, City, _), City\=To, route(City, To, [From]).

route(From, To, Route) :- dist(From, To, _), append(Route, [From], Ruta1), append(Ruta1, [To], Ruta), print_list(Ruta).
route(From, To, Route) :- dist(From, City, _), nonmember(City, Route), City\=To, append(Route, [From], Ruta), route(City, To, Ruta).
