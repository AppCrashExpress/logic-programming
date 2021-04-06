:- op(999, xfy, ':').

an_morf(In, Res):-
    append(Prefix, Other, In),
    an_prist(Prefix, PreCombined),
    append(Root, Suffix, Other),
    an_kor(Root, RootCombined),
    an_suff(Suffix, Rod, Plurality),
    ( %Since plural has no "rod", we can omit it.
        Rod = 'множ',
        Res = morf(prist(PreCombined), kor(RootCombined), chislo(Plurality)); %Notice the OR operator
        Res = morf(prist(PreCombined), kor(RootCombined), rod(Rod), chislo(Plurality))
    ), !.

an_morf(_, Res):- 
    Res = morf(prist('???'), kor('???'), rod('???'), chislo('???')).


%------------------------ Prefix block
an_prist(Prefix, Combined):-
    get_prefix(L),
    member(Prefix:Combined, L).

%------------------------ Root block
an_kor(Root, Combined):-
    get_root(L),
    member(Root:Combined, L).

%------------------------ Suffix block
an_suff(Suffix, Rod, Plurality):-
    get_suffix(L),
    member(Suffix:Rod:Plurality, L).


%------------------------ Database block
get_prefix([
    [] : '', % We can have no prefix at all
    ['в', 'ы'] : 'вы',
    ['и', 'з'] : 'из',
    ['о', 'т'] : 'от',
        %Custom
    ['о', 'б'] : 'об',
    ['д', 'о'] : 'до',
    ['п', 'о', 'д'] : 'под'
]).

get_root([
    ['у', 'ч'] : 'уч',
        %Custom
    ['х', 'о', 'д'] : 'ход',
    ['с', 'у', 'д'] : 'суд',
    ['у', 'в', 'е', 'ч'] : 'увеч'
]).

get_suffix([
    ['и', 'л']      : 'муж'  : 'един',
    ['и', 'л', 'а'] : 'жен'  : 'един',
    ['и', 'л', 'о'] : 'сред' : 'един',
    ['и', 'л', 'и'] : 'множ' : 'множ'
]).