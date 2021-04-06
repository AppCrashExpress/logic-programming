:-['tree.pl'].

motherInLaw(Husband, Mom):-
    setof(X, motherInLaw_assist(Husband, X), MomList),
    member(Mom, MomList).

motherInLaw_assist(Husband, Mom):-
    parents(_, Husband, Wife),
    parents(Wife, _, Mom).
