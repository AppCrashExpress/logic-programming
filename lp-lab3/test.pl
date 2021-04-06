door(a, b).
door(b, c). door(b, d).
door(c, d).
door(d, e). door(d, f).
door(e, g).
door(f, g).
door(h, i).

move(X, Y):-
    door(X, Y);
    door(Y, X).

prolong([X|T], [Y, X | T]):-
    move(X, Y),
    not(member(Y, [X|T])).

% bdth_search(+Init, +Goal, ?Path)
bdth_search(Init, Goal, Path):-
    bdth([[Init]], Goal, ReversePath),
    reverse(ReversePath, Path).

bdth([[Goal|Path]|_], Goal, [Goal|Path]).

bdth([First|Queue], Goal, RevPath):-
    findall(X, prolong(First, X), New),
    append(Queue, New, Queue1), !,
    bdth(Queue1, Goal, RevPath).

bdth([_|Queue], Goal, RevPath):-
    bdth(Queue, Goal, RevPath).


dfs_search(Init, Goal, Limit, Path):- 
    dfs([Init], Goal, Limit, ReversePath),
    reverse(ReversePath, Path).

dfs([Goal|T], Goal, _, [Goal|T]).
dfs(Stack, Goal, Depth, RevPath):-
    Depth > 0,
    prolong(Stack, Stack1),
    Depth1 is Depth - 1,
    dfs(Stack1, Goal, Depth1, RevPath).