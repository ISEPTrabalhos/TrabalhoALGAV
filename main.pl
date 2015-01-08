:- include('baseconhecimento.pl').

clear:-format('~c~s~c~s', [0x1b, "[H", 0x1b, "[2J"]).

gerar_estacoes:- findall(L, linha(_,L), LE), gerar_estacoes(LE, Estacoes), gerar_estacoes(Estacoes).

gerar_estacoes([]).
gerar_estacoes([H|T]):- gerar_estacoes(T), atom_string(H, E), assertz(estacoes(E)).

gerar_estacoes([],[]).
gerar_estacoes([H|T], LE):- gerar_estacoes(T,LR), append(LR, H, LE).