%Manually deducted answer -- They both lie, and the only day they both lie is tuesday. Speaker is Gek, Buddy is Chuk.


%-------------------------------------------------------- One go-getter
solve(Speaker, Buddy, Days):-
    statement1(Speaker, SLie),
    other(Speaker, Buddy),
    statement2(Buddy, BLie),
    possible_days(Speaker, SLie, Buddy, BLie, Days).

%-------------------------------------------------------- Facts block
days([mon, tue, wed, thu, fri, sat, sun]).

lies_fact(chuk, [mon, tue, wed]).
lies_fact(gek,  [tue, thu, sat]).

%-------------------------------------------------------- Statements block
statement1(Name, Lied):-
    adj(sun, Today),
    lies(chuk, Today),
    Name = gek, Lied = yes, !;
    Name = chuk, Lied = no.

statement2(Name, Lied):-
    statement3(Name, WasLie),
    WasLie = yes,
    Lied = yes, !;
    adj(Today, fri),
    lies(Name, Today),
    Lied = yes, !;
    Lied = no.

statement3(Name, Lied):-
    lies(Name, wed),
    Lied = yes, !;
    Lied = no.

%-------------------------------------------------------- Auxillary predicates
other(chuk, gek).
other(gek, chuk).

lies(Name, Day):- 
    lies_fact(Name, OnDays),
    member(Day, OnDays).

no_lies(Name, Day):-
    lies_fact(Name, OnDays),
    days(List),
    subtract(List, OnDays, NotOnDays),
    member(Day, NotOnDays).

adj(sun, mon). %As in adjacent
adj(Prev, Next):-
    days(List),
    nth0(Index,  List, Prev),
    nth0(Index1, List, Next),
    Index1 is Index + 1.

possible_days(Name1, Lied1, Name2, Lied2, Days):-
    Lied1 = yes, Lied2 = yes,
    findall(Day1,lies(Name1, Day1), List1),
    findall(Day2,lies(Name2, Day2), List2),
    intersection(List1, List2, Days), !;

    Lied1 = yes, Lied2 = no,
    findall(Day1,lies(Name1, Day1), List1),
    findall(Day2,no_lies(Name2, Day2), List2),
    intersection(List1, List2, Days), !;

    Lied1 = no, Lied2 = yes,
    findall(Day1,no_lies(Name1, Day1), List1),
    findall(Day2,lies(Name2, Day2), List2),
    intersection(List1, List2, Days), !;

    Lied1 = no, Lied2 = no,
    findall(Day1,no_lies(Name1, Day1), List1),
    findall(Day2,no_lies(Name2, Day2), List2),
    intersection(List1, List2, Days), !.
