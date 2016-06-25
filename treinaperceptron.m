# treinaperceptron.m
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
# NAO EH USADO NA MLP. ADICIONEI POR FAZER PARTE DA "BIBLIOTECA"
#
# Implementa o treinamento de um perceptron isolado 
# i.e. calculo dos pesos adequados a partir do conjunto
# de exemplos x e das respectivas etiquetas d usando taxa
# de aprendizado n
#
# Entradas:
#   n: taxa de aprendizado
#   x: conjunto de exemplos de treinamento
#   d: conjunto de etiquetas dos exemplos de entrada
#
# Saidas:
#   w: vetor de pesos do perceptron
#
# Autor
# =====
#
# Eduardo Vasconcelos
# <eduardovasconcelos@usp.br>
#

function w = treinaperceptron(n, x, d)

    w = zeros(1, size(x)(2));
    nSemMudarW = 0; # Por quantas instancias ja passou sem mudar os pesos
    px = 1; # Proxima posicao em x a ser usada no treinamento
    
    # O teste do laco eh se passou por todas as instancias sem mudar os pesos
    # Se sim => acabou o treinamento
    while(nSemMudarW < size(x)(1))
        
        y = perceptron(w, x(px,:));
        
        # Teste de erro
        if(y != d(px))
            w = w .+ n*(d(px) - y)*x(px,:);
            nSemMudarW = 0;
        else
            nSemMudarW = nSemMudarW + 1;
        end
        
        # Incremento circular de px
        if(px == size(x)(1))
            px = 1;
        else
            px = px + 1;
        end
    end

end
