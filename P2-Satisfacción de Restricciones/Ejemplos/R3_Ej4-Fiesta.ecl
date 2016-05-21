:- lib(ic).

party(List):-
    List = [P, C, R, T],
    List :: [0, 1],

    P + C #> 0,
    C + R #> 0,
    R + T #> 0,
    P + R #< 2,
    C + T #< 2,
    
    labeling(List).