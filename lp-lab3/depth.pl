initial([b, w, w, b, b, w, b, w, w]).
goal([w, w, w, w, w, b, b, b, b]).

% Reminder: Counting initial and result, it takes (14) states to get to the result

%---------------------------- DFS block
% dfs_search(+Init, +Goal, +Limit, -Path)
dfs_search(Init, Goal, Limit, Path):- 
    dfs([Init], Goal, Limit, ReversePath),
    reverse(ReversePath, Path).

dfs([Goal|T], Goal, _, [Goal|T]).
dfs(Stack, Goal, Depth, RevPath):-
    Depth > 0,
    prolong(Stack, Stack1),
    Depth1 is Depth - 1,
    dfs(Stack1, Goal, Depth1, RevPath).

%---------------------------- Swap block
prolong([First|Tail], [New, First | Tail]):-
    swap_adj(First, New),
    not(member(New, [First|Tail])).

swap_adj(State, Res):-
    append(Left, [H1, H2 | T], State),
    H1 \= H2,
    append(Left, [H2, H1 | T], Res).  

