:- lib(ic).

consistencia(Arcos):-
    Arcos = [A, B, C, D],
    Arcos :: [1..4],

    A #< B,
    D #< C,
    A #= C,
    D #< A,
    B #= C,

    labeling(Arcos).