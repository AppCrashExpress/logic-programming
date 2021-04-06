:- ['tree.pl'].
:- dynamic prev/1.

inquire(Question, Answer):-
    atomic_list_concat(LOfWords,' ', Question),
    s(Answer, LOfWords, []).

% Is X <relation> of Y
s(Answer) -->
    get_n(X, 2),
    get_r(Rel), ['of'], get_n(Y, 3),
    {
        reassert(X, Y),
        relationship(Rel, X, Y),
        Answer = 'Yes', !;
        Answer = 'No', !
    }.
s(Answer) -->
    get_n(X, 2), ['their'],
    get_r(Rel),
    {
        prev(Y),
        relationship(Rel, X, Y),
        Answer = 'Yes', !;
        Answer = 'No', !
    }.

% Does X have a <relation>
s(Answer) -->
    get_n(X, 1),
    ['have', 'a'], get_r(Rel),
    {
        reassert(X, X),
        relationship(Rel, _, X),
        Answer = 'Yes', ! ;
        Answer = 'No', !
    }.

% Who is a <relation> of Y
s(Answer) -->
    ( ['Who'] | ['who'] ), ['is', 'a'], get_r(Rel),
    ['of'], get_n(Y, 3),
    {
        bagof(X, relationship(Rel, X, Y), Answer),
        reassert(Y, Y), !;
        Answer = 'I dont know', !
    }.
s(Answer) -->
    ( ['Who'] | ['who'] ), ['is'], ['their'],
    get_r(Rel),
    {
        prev(Y), 
        bagof(X, relationship(Rel, X, Y), Answer), !;
        Answer = 'I dont know', !
    }.


% Who is X to Y
s(Answer) -->
    ( ['Who'] | ['who'] ), get_n(X, 2),
    ['to'], get_n(Y, 3),
    {
        relationship(Answer, X, Y),
        reassert(X, Y), !;
        Answer = 'I dont know', !
    }.

% Whose <relation> is X
s(Answer) -->
    ( ['Whose'] | ['whose'] ),  get_r(Rel),
    get_n(X, 2),
    {
        bagof(Y, relationship(Rel, X, Y), Answer),
        reassert(X, X), !;
        Answer = 'I dont know', !
    }.

% How many <relation> does X have
s(Answer) -->
    ( ['How'] | ['how'] ), ['many'], 
    get_r(Rel),
    get_n(X, 1), ['have'],
    {
        bagof(Y, relationship(Rel, Y, X), List),
        length(List, Answer),
        reassert(X, X), !;
        Answer = '0 or not in database', !
    }.

get_n(FullName, 1) -->
    (['Does'] | ['does']),
    [Name, Surname],
    {
        atomic_list_concat([Name, Surname], ' ', FullName),
        confirm_name(FullName), !
    }.
get_n(FullName, 1) -->
    ( ['Do'] | ['do'] ), ['they'],
    { prev(FullName), ! }.

get_n(FullName, 2) -->
    ( ['Is'] | ['is'] ),
    [Name, Surname],
    {
        atomic_list_concat([Name, Surname], ' ', FullName),
        confirm_name(FullName), !
    }.
get_n(FullName, 2) -->
    ( ['Are'] | ['are'] ), ['they'],
    { prev(FullName), ! }.

get_n(FullName, 3) -->
    [Name, Surname],
    {
        atomic_list_concat([Name, Surname], ' ', FullName),
        confirm_name(FullName), !
    }.
get_n(FullName, 3) -->
    ['them'],
    { prev(FullName), ! }.


reassert(X, Y):-
    prev(X);
    prev(Y);
    retractall(prev(_)),
    asserta(prev(X)), !.
% Every question will have a priority for 'them', so
% if we used previous name on neither X nor Y,
% it gets rebound to X.

%%%
% Depluralize relation
%%%
get_r('sibling')         --> ['sibling'] | ['siblings'].
get_r('child')           --> ['child'] | ['kids'].
get_r('mother')          --> ['mother'] | ['mothers'].
get_r('father')          --> ['father'] | ['fathers'].
get_r('grandchild')      --> ['grandchild'] | ['grandkids'].
get_r('grandmother')     --> ['grandma'] | ['grandmas'] | ['grandmother'] | ['grandmothers'].
get_r('grandfather')     --> ['grandpa'] | ['grandpas'] | ['grandfather'] | ['grandfathers'].
get_r('mother-in-law')   --> ['mother-in-law'] | ['mothers-in-law'].
get_r('son-in-law')      --> ['son-in-law'] | ['sons-in-law'].
get_r('daughter-in-law') --> ['daughter-in-law'] | ['daughters-in-law'].

confirm_name(FullName):-
    parents(FullName, _, _);
    parents(_, FullName, _);
    parents(_, _, FullName).


%%%
% Relationships
%%%

relationship('sibling', First, Second):-
    parents(First, Husband, Wife),
    parents(Second, Husband, Wife),
    First \= Second.

relationship('child', Child, Mom):- parents(Child, _, Mom).
relationship('mother', Mom, Child):- parents(Child, _, Mom).

relationship('child', Child, Father):- parents(Child, Father, _).
relationship('father', Father, Child):- parents(Child, Father, _).

relationship('grandchild', Grandchild, Grandfather):-
    parents(Grandchild, Father, Mom),
    (
        parents(Father, Grandfather, _);
        parents(Mom, Grandfather, _)
    ).
relationship('grandfather', Grandfather, Grandchild):-
    parents(Grandchild, Father, Mom),
    (
        parents(Father, Grandfather, _);
        parents(Mom, Grandfather, _)
    ).


relationship('grandchild', Grandchild, Grandmother):-
    parents(Grandchild, Father, Mom),
    (
        parents(Father, _, Grandmother);
        parents(Mom, _, Grandmother)
    ).
relationship('grandmother', Grandmother, Grandchild):-
    parents(Grandchild, Father, Mom),
    (
        parents(Father, _, Grandmother);
        parents(Mom, _, Grandmother)
    ).


relationship('daughter-in-law', Wife, Mother):-
    parents(Husband, _, Mother),
    parents(_, Husband, Wife).

relationship('son-in-law', Husband, Mother):-
    parents(Wife, _, Mother),
    parents(_, Husband, Wife).

relationship('mother-in-law', Mother, Wife):-
    setof(X, mil_daughter(Wife, X), MomList),
    member(Mother, MomList).

relationship('mother-in-law', Mother, Husband):-
    setof(X, mil_husband(Husband, X), MomList),
    member(Mother, MomList).


mil_daughter(Wife, Mom):-
    parents(_, Husband, Wife),
    parents(Husband, _, Mom).

mil_husband(Husband, Mom):-
    parents(_, Husband, Wife),
    parents(Wife, _, Mom).
