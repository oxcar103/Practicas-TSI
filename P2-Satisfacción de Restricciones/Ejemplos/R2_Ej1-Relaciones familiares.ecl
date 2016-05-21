% Me
male(oscar).

% Father's branch - Males
male(rosendo).
male(manuel1).
male(alvaro1).
male(angel1).
male(jesus1).
male(alvaro2).
male(ruben1).
male(juan).
male(angel2).

% Mother's branch - Males
male(francisco).
male(javier1).
male(fernando1).
male(delfin).
male(javier2).
male(jesus2).
male(fernando2).
male(ruben2).
male(javier3).
male(manuel2).
male(david).

% Father's branch - Females
female(angeles).
female(antonia2).
female(maria1).
female(yolanda).
female(lorena).
female(noelia).
female(maria3).
female(jessica).

% Mother's branch - Females
female(antonia1).
female(adora).
female(maria2).
female(francisca).
female(cristina).

% Father's branch - Relations
parent(rosendo, manuel1).
parent(rosendo, alvaro1).
parent(rosendo, angel1).
parent(rosendo, jesus1).
parent(angeles, manuel1).
parent(angeles, alvaro1).
parent(angeles, angel1).
parent(angeles, jesus1).
parent(manuel1, lorena).
parent(manuel1, ruben2).
parent(antonia2, lorena).
parent(antonia2, ruben2).
parent(alvaro1, alvaro2).
parent(alvaro1, noelia).
parent(alvaro1, jessica).
parent(maria1, alvaro2).
parent(maria1, noelia).
parent(maria1, jessica).
parent(angel1, oscar).
parent(jesus1, maria3).
parent(jesus1, juan).
parent(jesus1, angel2).
parent(yolanda, maria3).
parent(yolanda, juan).
parent(yolanda, angel2).

% Mother's branch - Relations
parent(francisco, adora).
parent(francisco, francisca).
parent(francisco, maria2).
parent(francisco, delfin).
parent(antonia1, adora).
parent(antonia1, francisca).
parent(antonia1, maria2).
parent(antonia1, delfin).
parent(fernando1, javier2).
parent(fernando1, jesus2).
parent(fernando1, fernando2).
parent(fernando1, ruben1).
parent(fernando1, manuel2).
parent(adora, javier2).
parent(adora, jesus2).
parent(adora, fernando2).
parent(adora, ruben1).
parent(adora, manuel2).
parent(francisca, oscar).
parent(javier1, javier3).
parent(javier1, david).
parent(maria2, javier3).
parent(maria2, david).

% Functions
mother(X, Y):- parent(X,Y), female(X).
father(X, Y):- parent(X,Y), male(X).
grandmother(X, Y):- mother(X, Z), parent(Z, Y).
grandfather(X, Y):- father(X, Z), parent(Z, Y).
ancestor(X, Y):- parent(X, Y); parent(X, Z), ancestor(Z, Y).
brother(X, Y):- mother(Z, X), mother(Z, Y), father(T, X), father(T, Y), male(X), X\=Y.
sister(X, Y):- mother(Z, X), mother(Z, Y), father(T, X), father(T, Y), female(X), X\=Y.
sibling(X, Y):- brother(X, Y); sister(X, Y).
uncle(X, Y):- brother(X, Z), parent(Z, Y).
cousing(X, Y):- parent(Z, X), sibling(Z, T), parent(T, Y), X\=Y.