:- lib(ic).

renfe(Train):-
    Train = [T1, T2, T3, T4],
    Train :: [1..3],

    T1 #\= T2,
    T2 #\= T3,
    T2 #\= T4,
    T3 #\= T4,

    T3 #\= 3,
    T4 #\= 2,
    T4 #\= 3,
    
    labeling(Train).