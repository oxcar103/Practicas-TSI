dist(hamburg, bremen, 80).
dist(hamburg, berlin, 230).
dist(bremen, dortmund, 200).
dist(hannover, nuernberg, 380).
dist(dortmund, koeln, 80).
dist(kassel, frankfurt, 180).
dist(nuernberg, muenchen, 160).
dist(hamburg, hannover, 110).
dist(bremen, hannover, 100).
dist(hannover, kassel, 140).
dist(dortmund, kassel, 130).
dist(kassel, wuerzburg, 180).
dist(frankfurt, wuerzburg, 110).

dist(X, Y, Km) :- dist(Y, X, Km).