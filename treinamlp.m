# treinamlp.m
#
# Licenca
# =======
#
# Copyright (c) 2016 Eduardo Santos Medeiros de Vasconcelos
#
# Todos os arquivos que constituem este software sao distribuidos
# sob a licenca MIT (disponivel em mit-license.org)
#
# Descricao
# =========
#
# Implementa treinamento de rede MLP
#
# Entradas:
#   n: taxa de aprendizado
#   x: vetores de treinamento
#   d: saidas esperadas dos vetores de treinamento
#   arq: arquitetura da rede
#       e.g. arq = [ 2 1 ] define uma rede totalmente
#       conectadacom 2 neuronios de entrada e 1 de saida
#       cujo numero de entradas eh igual a dimensao dos
#       vetores de treinamento e cujo numero de saidas
#       eh igual ao numero de neuronios de saida
#   N: no. maximo de iteracoes do treinamento
#   a: parametro a da funcao sigmoide
#   e: erro quadratico medio/epoca admissivel
#   alfa: parametro de momentum
#
# Saidas:
#   w: pesos sinapticos da rede
#   em: erro quadratico medio da rede para cada epoca
#
# Autor
# =====
#
# Eduardo Vasconcelos
# <eduardovasconcelos@usp.br>
#

function [w em] = treinamlp(n, x, d, arq, N, a, e, alfa)
    
    # A indexacao de pesos sinapticos entre duas camadas quaisquer eh
    # sempre (i, j) onde i eh o indice da entrada/neuronio na camada de
    # onde sai e j eh o indice do neuronio na camada onde chega a sinapse
    
    # Pesos do vetor de entrada para a primeira camada oculta
    w = { rand(size(x(1,:))(2), arq(1)) };
    wMom = { zeros(size(x(1,:))(2), arq(1)) }; # Momentum
    
    # Pesos entre camadas, ate a camada de saida, que eh a ultima
    for i = 1:(size(arq)(2)-1)
        w{end + 1} = rand(arq(i), arq(i+1));
        wMom{end + 1} = zeros(arq(i), arq(i+1));
    end

    em = []; # Array de erro quadratico medio/epoca
    emp = 0; # Erro quadratico medio/epoca (parcial)
    empa = 0;
    nIteracoes = 1;

    do        
        for i = 1:size(x)(1) # Para cada entrada
        
            g = {}; # Gradiente da rede
            
            [y dsigmv] = classificaentrada(w, x(i,:), arq, a); # Camada de saida            
            g{end + 1} = (d(i,:) .- y{end}) .* dsigmv{end}; # Gradiente de saida            
            
            w{end} = alfa .* wMom{end} + w{end} + (n .* g{end} .* y{end-1}'); # Atualizacao de pesos da saida
            wMom{end} = (n .* g{end} .* y{end-1}');
            
            emp = emp + sum((d(i,:) .- y{end}).^2); # Atualizacao do erro medio da rede
            
            for j = (size(arq)(2)-1):-1:1 # Para cada camada oculta (de tras p frente)

                g{end + 1} = dsigmv{j} .* sum(g{end} * w{j+1}'); # Gradiente da camada
            
                # Atualizacao de pesos da camada
                if (j ~= 1)
                    w{j} = alfa .* wMom{j} + w{j} + (n .* g{end} .* y{j-1}');
                    wMom{j} = (n .* g{end} .* y{j-1}');
                else
                    w{j} = alfa .* wMom{j} + w{j} + (n .* g{end} .* x(i,:)');
                    wMom{j} = (n .* g{end} .* x(i,:)');
                end
            end                                       
        end
        
        em = [ em emp/(2*size(x)(1)) ];
   
        # Atualizacao do console
        clc
        printf("n: %d/%d(max)\nem: %f\ndem: %f\n", nIteracoes, N, em(end), em(end)-empa);
        nIteracoes = nIteracoes + 1;
        empa = em(end);
        emp = 0;
   
        # Troca da ordem das entradas aleatoriamente
        xd = [ x d ];
        p = randperm(columns(xd));
        xd = sortrows(xd, p);

        x = xd(:,1:end-columns(d));

        d = xd(:,end-columns(d)+1:end);
        
    until (nIteracoes > N || em(end) < e)
    
end