:- op(999, xfy, ':').

an_morf(In, Out):-
    an_morf(Prefix:Root:Rod:Plurality, In, []),
    ( %Since plural has no "rod", we can omit it.
        Rod = 'множ',
        Out = morf(prist(Prefix), kor(Root), chislo(Plurality)); %Notice the OR operator
        Out = morf(prist(Prefix), kor(Root), rod(Rod), chislo(Plurality))
    ), !.


an_morf(Prefix:Root:Rod:Plurality) --> 
    an_prist(Prefix),
    an_kor(Root),
    an_suff(Rod, Plurality).

%------------------------ Prefix block
an_prist('')    --> []. % We can have no prefix at all
an_prist('вы')  --> ['в', 'ы'].
an_prist('из')  --> ['и', 'з'].
an_prist('от')  --> ['о', 'т'].
% Custom
an_prist('об')  --> ['о', 'б'].
an_prist('до')  --> ['д', 'о'].
an_prist('под') --> ['п', 'о', 'д'].

%------------------------ Root block
an_kor('уч')   --> ['у', 'ч'].
% Custom
an_kor('ход')  --> ['х', 'о', 'д'].
an_kor('суд')  --> ['с', 'у', 'д'].
an_kor('увеч') --> ['у', 'в', 'е', 'ч'].

%------------------------ Suffix block
an_suff('муж',  'един') --> ['и', 'л'].
an_suff('жен',  'един') --> ['и', 'л', 'а'].
an_suff('сред', 'един') --> ['и', 'л', 'о'].
an_suff('множ', 'множ') --> ['и', 'л', 'и'].