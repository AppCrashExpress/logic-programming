initial([b, w, w, b, b, w, b, w, w]).
goal([w, w, w, w, w, b, b, b, b]).

% Reminder: Counting initial and result, it takes (14) states to get to the result

%---------------------------- BFS block
% bfs_search(+Init, +Goal, -Path)
bfs_search(Init, Goal, Limit, Path):-
    bfs([[Init]], Goal, Limit, ReversePath),
    reverse(ReversePath, Path).

bfs([[Goal|Path]|_], Goal, _, [Goal|Path]):- !.

bfs([First|Queue], Goal, Limit, RevPath):-
    length(First, Size),
    Size =< Limit,    
    findall(X, prolong(First, X), New),
    append(Queue, New, Queue1), !,
    bfs(Queue1, Goal, Limit, RevPath).

bfs([_|Queue], Goal, Limit, RevPath):-
    bfs(Queue, Goal, Limit, RevPath).

%---------------------------- Swap block
prolong([First|Tail], [New, First | Tail]):-
    swap_adj(First, New),
    not(member(New, [First|Tail])).

swap_adj(State, Res):-
    append(Left, [H1, H2 | T], State),
    H1 = 'b',
    H2 = 'w',
    append(Left, [H2, H1 | T], Res).  
