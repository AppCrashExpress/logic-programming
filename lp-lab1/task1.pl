%Notice: all predicates were ran on SWI prolog, since
%latest version of GNU prolog, 1.4.5,
%confirmed to be broken.
:- ['base.pl'].


%Part one.one

cutDefault(List,N,Res):-
    appnd(Res, _, List),
    len(Res, N), !.

%Part one.two

listLen([], 0).
listLen([_|T], X1):-
  listLen(T, X),
  X1 is X + 1.

lastPeek([], [], _).
lastPeek([H|T], [Prev|List], Prev):-
    lastPeek(T, List, H).

lastDelete([H|T], Res):-
    lastPeek(T, Res, H).

cutLast(Res, 0, Res).
cutLast(List, N1, Res):-
    lastDelete(List, Temp),
    cutLast(Temp, N, Res),
    N1 is N + 1.

cut(List, N, Res):-
    listLen(List, Size),
    DeleteAmount is Size - N,
    cutLast(List, DeleteAmount, Res), !.
    
%Part two.one

minPosDefault(List, Pos):-
    min_list(List, X),
    nth0(Pos, List, X). %nth for GNU prolog
   

%Part two.two

compMin([], Min, Min).
compMin([H|T], Curr, Min):-
    Curr > H,
    compMin(T, H, Min);
    Curr =< H,
    compMin(T, Curr, Min).

min([H|T], Num):- compMin(T, H, Num).

findPos([Num|_], Num, 0).
findPos([_|T], Num, Pos1):-
    findPos(T, Num, Pos),
    Pos1 is Pos + 1.

minPos(List, Pos):-
    min(List, Num),
    findPos(List, Num, Pos).

%Example

checkError([H|_], 0):- H < 0, !.
checkError([_|T], Pos1):-
    checkError(T, Pos),
    Pos1 is Pos + 1.

cutError(List, Res):-
    minPos(List, Pos),
    checkError(List, Pos),
    cut(List, Pos, Res), !;
    Res = List.
