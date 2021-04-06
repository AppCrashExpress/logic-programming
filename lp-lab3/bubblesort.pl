initial([b, w, w, b, b, w, b, w, w]).
goal([w, w, w, w, w, b, b, b, b]).

% Reminder: Counting initial and result, it takes (14) states to get to the result

start(Init, Res):-
    goal(Goal),
    bubblesort(Res, Goal, Init).

bubblesort(Current, _, Current).
bubblesort(X, Goal, List):-
    List \= Goal, 
    swap_adj(List, Swapped),
    bubblesort(X, Goal, Swapped).

swap_adj(State, Res):-
    append(Left, [H1, H2 | T], State),
    H1 = 'b',
    H2 = 'w',
    append(Left, [H2, H1 | T], Res), !.  