% Task 2: Relational Data
% Picked assigment 2.
:- ['base.pl'].
:- ['three.pl'].

%Basis for iterating grades
findByNameR([grade(Name, Grade)|T],X,Y):-
    Name = X,
    Grade = Y; %Notice the OR here
    findByNameR(T,X,Y).

findByName(Subject,Grade):-
    student(_, _, List),
    findByNameR(List,Subject,Grade).

%Exercise 1: find average for each subject
average(X, Res):-
    subject(X,_),
    bagof(Grade, findByName(X,Grade), GradeList),
    length(GradeList, Size),
    sum_list(GradeList, Sum),
    Res is Sum / Size.

%Exercise 2: find fail per each group 
getGroups(List):-
    findall(Group, student(Group,_,_), L),
    sort(L, List).

failed([], _):- fail.
failed([H|T], Bool):-
    H = grade(_, 2),
    Bool is 1, !;
    failed(T, Bool).

failedWrapper(Group, Bool):-
    student(Group, _, List),
    failed(List, Bool).
    

failedStudents(Group, Sum):-
  bagof(Bool, failedWrapper(Group, Bool), BoolVector), %bagof is a magical thing; best left untouched
    len(BoolVector, Sum).

%Exercise 3: find fail per each subject
failedBySubject(Name ,Sum):-
    subject(Name,_),
    findall(2, findByName(Name, 2), GradeList),
    length(GradeList, Sum).

