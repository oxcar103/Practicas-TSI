:- lib(ic).


vecindario(Casas):-
    Casas = [A, B, C, D],
    Casas :: [1 .. 4],

    alldifferent(Casas),

    D #< B,
    B #> A,
    (B #> C+1; C #> B+1),
    C #\= 4,
    D #\= 2,

    labeling(Casas).