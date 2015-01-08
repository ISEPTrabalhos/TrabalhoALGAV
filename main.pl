:- include('baseconhecimento.pl').

/* instrucao para limpar consola */
clear:-format('~c~s~c~s', [0x1b, "[H", 0x1b, "[2J"]).

/* metodologia para gerar estacoes */
gerar_estacoes:- findall(L, linha(_,L), LE), gerar_estacoes(LE, Estacoes), gerar_estacoes(Estacoes).
gerar_estacoes([]).
gerar_estacoes([H|T]):- gerar_estacoes(T), atom_string(H, E), assertz(estacoes(E)).
gerar_estacoes([],[]).
gerar_estacoes([H|T], LE):- gerar_estacoes(T,LR), append(LR, H, LE).

/* metodologia para gerar cruzamentos */
gerar_cruzamentos:-findall(_,cruzamento,_).
cruzamento:-linha(A,L1),
	    linha(B,L2),
	    intersection(L1,L2,L),A\==B,
	    L\==[],assertz(cruza(A,B,L)).