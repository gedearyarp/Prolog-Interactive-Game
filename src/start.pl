:- dynamic(start_game/1).

start_game(false).

start :-
    ['map.pl'],

    retract(start_game(false)), !,
    asserta(start_game(true)),

    write(' █████╗ ██████╗  ██████╗ █████╗ ███╗   ██╗███████╗'), nl,
    write('██╔══██╗██╔══██╗██╔════╝██╔══██╗████╗  ██║██╔════╝'), nl,
    write('███████║██████╔╝██║     ███████║██╔██╗ ██║█████╗  '), nl, 
    write('██╔══██║██╔══██╗██║     ██╔══██║██║╚██╗██║██╔══╝  '), nl,
    write('██║  ██║██║  ██║╚██████╗██║  ██║██║ ╚████║███████╗'), nl, 
    write('╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝'), nl.