edge(a, b).
edge(a, c).
edge(b, d).
edge(c, d).
edge(d, e).

path(X, Y):- edge(X, Y); edge(X, Z), path(Z, Y).