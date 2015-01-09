:- include('baseconhecimento.pl').

/* para limpar estacoes : retractall(estacoes(E)). */

/* instrucao para limpar consola */
clear:-format('~c~s~c~s', [0x1b, "[H", 0x1b, "[2J"]).

/* metodologia para gerar estacoes, semelhante exercicio da PL */
gerar_estacoes:-findall(L,linha(_,L),LT),gerar_estacoes(LT,Estacoes),assertz(estacoes(Estacoes)).
gerar_estacoes([],[]).
gerar_estacoes([H|T],LT):-gerar_estacoes(T,LR), append(LR, H, LT).

/* metodologia para gerar cruzamentos */
gerar_cruzamentos:-findall(_,criar_cruzamento,_).
criar_cruzamento:-linha(A,L1),
	    linha(B,L2),
	    intersection(L1,L2,L),A\==B,
	    L\==[],assertz(cruzamento(A,B,L)).

/* gerar ligacoes entre estacoes */
criar_ligacoes_estacoes:-findall(_, (linha(Linha,Listagem), 
					criar_ligacoes_estacoes(Linha, Listagem, Listagem)), _).
criar_ligacoes_estacoes(_, _, [_|[]]).
criar_ligacoes_estacoes(Linha, [Estacao|Resto], [Estacao, Seguinte|_]):-
						criar_ligacoes_estacoes(Linha, Resto, Resto), 
						assertz(liga(Estacao, Seguinte, Linha, 3)),
						assertz(liga(Seguinte, Estacao, Linha, 3)).
						/* vai gerar regras do tipo liga com
						estacao, proxima_estacao, linha_que_pertence, tempo_de_viagem */