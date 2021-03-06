:- dynamic(currentQuest/2).
:- dynamic(fishQuest/1).
:- dynamic(cropQuest/1).
:- dynamic(dairyQuest/1).
% :- dynamic(inQuest/1).
% :- dynamic(gold/1).
% :- dynamic(xp/1).
% :- dynamic(totalGold/1).
% inQuest(true).
% gold(500).
% exp(5).
% totalGold(200).



% Crop, Fish, Dairy, Gold, Xp

initQuest :-
    currentQuest(_,_),nl,
    write('Anda sedang menjalankan quest. Sarannya sih, selesaiin dulu, daripada keos.'),
    nl, !.

initQuest :-
    \+(currentQuest(_,_)),
    level(Level),
    random(1,10,Crop),
    random(1,10,Fish),
    random(1,10,Dairy),
    Temp is Level * 0.75,
    LevelMultiplier is ceiling(Temp),
    G is (Crop+Fish+Dairy)*5*LevelMultiplier,
    X is (Crop+Fish+Dairy)*10*LevelMultiplier,
    asserta(currentQuest(G,X)),
    asserta(fishQuest(Fish)),
    asserta(cropQuest(Crop)),
    asserta(dairyQuest(Dairy)),
    write('Anda mendapat quest baru. Kumpulkan '), write(Crop), write(' buah crop, '),
    write(Fish), write(' ekor ikan, dan '), write(Dairy), write(' buah dairy. Goodluck!'), nl,
    format('Bounty: ~w Gold, ~w XP\n', [G,X]),
    retract(mapObject(_,_,'Q')),
    !.

checkQuest :-
    \+fishQuest(0),
    \+cropQuest(0),
    \+dairyQuest(0),
    !.

checkQuest :-
    fishQuest(0),
    cropQuest(0),
    dairyQuest(0),
    currentQuest(G,X),
    gold(OldG),
    totalGold(OldTGold),
    exp(OldX),
    NewG is G + OldG,
    NewTGold is OldTGold + G,
    NewX is X + OldX,
    retract(gold(_)),
    asserta(gold(NewG)),
    retract(totalGold(_)),
    asserta(totalGold(NewTGold)),
    retract(exp(_)),
    asserta(exp(NewX)),
    retract(currentQuest(_,_)),
    write('Selamat, anda telah menyelesaikan Quest!'), nl,
    write('Gold yang didapat: '), write(G), nl,
    write('Experience yang didapat: '), write(X),nl,
    newQuest,
    !.

newQuest :-
    mapSize(LimX, LimY),
    random(1, LimX, X),
    random(1, LimY, Y),
    (mapObject(X,Y,_) -> newQuest;
    \+mapObject(X,Y,_) -> asserta(mapObject(X,Y,'Q'))),
    !.

quest :-
    \+inQuest(_),
    \+currentQuest(_,_),
    write('Tidak ada quest yang sedang dijalankan.'),
    !.

quest :-
    currentQuest(_,_),
    write('Anda sedang menjalankan quest. Sisa aktivitas yang dibutuhkan: '),nl,
    (fishQuest(Fish) -> write('Fish: '), write(Fish), nl),
    (cropQuest(Crop) -> write('Crop: '), write(Crop), nl),
    (dairyQuest(Dairy) -> write('Dairy: '), write(Dairy), nl),
    !.

quest :- 
    inQuest(_),
    \+currentQuest(_,_),
    write('Anda menemukan sebuah Quest!'),nl,
    initQuest,
    !.

decrementFish :-
    \+(fishQuest(_)),
    !.

decrementFish :-
    fishQuest(Fish),
    X is Fish - 1,
    (X >= 0 -> X is X;
    X < 0 -> X is 0),
    retract(fishQuest(_)),
    asserta(fishQuest(X)),
    checkQuest,
    !.

decrementCrop :-
    \+(fishQuest(_)),
    !.

decrementCrop :-
    cropQuest(Crop),
    X is Crop - 1,
    (X >= 0 -> X is X;
    X < 0 -> X is 0),
    retract(cropQuest(_)),
    asserta(cropQuest(X)),
    checkQuest,
    !.

decrementDairy(N) :-
    N is N,
    \+(dairyQuest(_)),
    !.

decrementDairy(N) :-
    dairyQuest(Dairy),
    (N > Dairy -> X is 0;
    Dairy >= N -> X is Dairy-N),
    retract(dairyQuest(_)),
    asserta(dairyQuest(X)),
    checkQuest,
    !.