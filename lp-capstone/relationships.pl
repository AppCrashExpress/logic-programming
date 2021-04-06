:-['tree.pl'].

relative('self', First, First):- !.
relative(Relation, First, Last):-
    bfs_search(First, Last, 1000, [First | Rest]),
    reverse(Rest, RevPath),
    relate(RevPath, First, [Actual | Chain]),
    (
        var(Relation),
        Relation = [Actual | Chain];
        not(var(Relation)),
        Relation = Actual  
    ).

relate([Last], First, [Add]):-
    relationship(Add, First, Last), !.

relate([Last|Path], First, [Add|Rest]):-
    relate(Path, First, Rest),
    relationship(Add, First, Last).

%------------------------------------------------------------- Search

bfs_search(Init, Goal, Limit, Path):-
    bfs([[Init]], Goal, Limit, ReversePath),
    reverse(ReversePath, Path).

bfs([[Goal|Path]| OtherPaths], Goal, _, [Goal|Path]):-
    not(member([Goal|Path], OtherPaths)).

bfs([First|Queue], Goal, Limit, RevPath):-
    length(First, Size),
    Size =< Limit,    
    findall(X, prolong(First, X), New),
    append(Queue, New, Queue1), !,
    bfs(Queue1, Goal, Limit, RevPath).

prolong([First|Tail], [New, First | Tail]):-
    connected(First, New),
    not(member(New, [First|Tail])).

connected(Node, Adjacent):-
    parents(Node, Adjacent, _);
    parents(Adjacent, Node,_);
    parents(_, Node, Adjacent);
    parents(_, Adjacent, Node);
    parents(Node, _, Adjacent);
    parents(Adjacent, _, Node).

%------------------------------------------------------------- Relationships

relationship('sibling', First, Second):-
    parents(First, Husband, Wife),
    parents(Second, Husband, Wife),
    First \= Second.

relationship('child - mother', Child, Mom):- parents(Child, _, Mom).
relationship('mother - child', Mom, Child):- parents(Child, _, Mom).

relationship('child - father', Child, Father):- parents(Child, Father, _).
relationship('father - child', Father, Child):- parents(Child, Father, _).

relationship('grandchild - grandfather', Grandchild, Grandfather):-
    parents(Grandchild, Father, Mom),
    (
        parents(Father, Grandfather, _);
        parents(Mom, Grandfather, _)
    ).
relationship('grandfather - grandchild', Grandfather, Grandchild):-
    parents(Grandchild, Father, Mom),
    (
        parents(Father, Grandfather, _);
        parents(Mom, Grandfather, _)
    ).


relationship('grandchild - grandmother', Grandchild, Grandmother):-
    parents(Grandchild, Father, Mom),
    (
        parents(Father, _, Grandmother);
        parents(Mom, _, Grandmother)
    ).
relationship('grandmother - grandchild', Grandmother, Grandchild):-
    parents(Grandchild, Father, Mom),
    (
        parents(Father, _, Grandmother);
        parents(Mom, _, Grandmother)
    ).


relationship('daughter-in-law - mother-in-law', Wife, Mother):-
    parents(Husband, _, Mother),
    parents(_, Husband, Wife).

relationship('son-in-law - mother-in-law', Husband, Mother):-
    parents(Wife, _, Mother),
    parents(_, Husband, Wife).

relationship('daughter-in-law - mother-in-law', Mother, Wife):-
    setof(X, mil_daughter(Wife, X), MomList),
    member(Mother, MomList).

relationship('son-in-law - mother-in-law', Mother, Husband):-
    setof(X, mil_husband(Husband, X), MomList),
    member(Mother, MomList).


mil_daughter(Wife, Mom):-
    parents(_, Husband, Wife),
    parents(Husband, _, Mom).

mil_husband(Husband, Mom):-
    parents(_, Husband, Wife),
    parents(Wife, _, Mom).
