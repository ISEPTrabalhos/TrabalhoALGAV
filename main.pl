:- include('baseconhecimento.pl').

/* para limpar estacoes : retractall(estacoes(E)). */

/* para ver tempo de resposta : use_module(library(statistics)). % time/1 */

/* ver listas completas: set_prolog_flag(toplevel_print_options,
                   [quoted(true), portray(true)]). */

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

:-dynamic liga/3.

/* gerar ligacoes entre estacoes */
criar_ligacoes_estacoes:-findall(_, (linha(Linha,Listagem), 
					criar_ligacoes_estacoes(Linha, Listagem, Listagem)), _).
criar_ligacoes_estacoes(_, _, [_|[]]).
criar_ligacoes_estacoes(Linha, [Estacao|Resto], [Estacao, Seguinte|_]):-
						criar_ligacoes_estacoes(Linha, Resto, Resto),
						\+liga(Estacao, Seguinte, 3),
						assertz(liga(Estacao, Seguinte, 3)),
						\+liga(Seguinte, Estacao, 3),
						assertz(liga(Seguinte, Estacao, 3)).
						/* vai gerar regras do tipo liga com
						estacao, proxima_estacao, linha_que_pertence, tempo_de_viagem */

/* A* */
hbf(Orig,Dest,Perc,Total):-
            estimativa(Orig,Dest,H), F is H + 0, % G = 0
            time((hbf1([c(F/0,[Orig])],Dest,P,Total),
            reverse(P,Perc))).

hbf1(Percursos,Dest,Percurso,Total):-
            menor_percurso(Percursos,Menor,Restantes),
            percursos_seguintes(Menor,Dest,Restantes,Percurso,Total).

percursos_seguintes(c(_/Dist,Percurso),Dest,_,Percurso,Dist):- Percurso=[Dest|_].

percursos_seguintes(c(_,[Dest|_]),Dest,Restantes,Percurso,Total):-!,
    hbf1(Restantes,Dest,Percurso,Total).

percursos_seguintes(c(_/Dist,[Ult|T]),Dest,Percursos,Percurso,Total):-
    findall(c(F1/D1,[Z,Ult|T]),proximo_no(Ult,T,Z,Dist,Dest,F1/D1),Lista),
    append(Lista,Percursos,NovosPercursos),
    hbf1(NovosPercursos,Dest,Percurso,Total).

proximo_no(X,T,Y,Dist,Dest,F/Dist1):-
                liga(X,Y,Z),
                \+member(Y,T),
                Dist1 is Dist + Z,
                estimativa(Y,Dest,H), F is H + Dist1.

menor_percurso([H|Percurso], Menor, [H| Percurso1]):- 
menor_percurso(Percurso, Menor, Percurso1),
    menor(H,Menor),!.

menor_percurso([H|T],H,T).

menor(c(A1|B1,_), c(A2,B2,_)):- As1 is A1 + B1, As2 is A2 + B2, As2 < As1.

%estimativa(C1,C2,Est):-
%        cidade(C1,X1,Y1),
%        cidade(C2,X2,Y2),
%        DX is X1-X2,
%        DY is Y1-Y2,
%        Est is sqrt(DX*DX+DY*DY).

estimativa(_,_,0). % para desprezar a heurística.