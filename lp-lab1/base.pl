len([], 0).
len([_|T], X1):-
                len(T, X),
                X1 is X + 1.

mem(X, [X|_]).
mem(X, [_|T]):- mem(X, T).

appnd([], Z, Z).
appnd([X|T1], Z, [X|T2]):-appnd(T1, Z, T2).

rm(X, [X|T], T).
rm(X, [H|T], [H|Res]):- rm(X, T, Res).

perm([],[]).
perm(X,[H|T]):-
                rm(H,X,T1),
                perm(T1,T).

subl([], _).
subl([X|T1], [X|T2]):- subl(T1,T2).
subl([X|T1], [_|T2]):- subl([X|T1], T2).
