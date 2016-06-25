# perceptron.m
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
# Implementa o calculo da saida do perceptron a partir do vetor de pesos e
# da instancia de entrada
#
# Entradas:
#   w: vetor de pesos do perceptron
#   x: instancia de entrada
#   a: parametro a da funcao sigmoide
#   f: funcao de saida
#       default: sinal (0 retorna 1)
#       'logi': logistica
#       'tanh': tangente hiperbolica
#
# Saidas:
#   y: saida do perceptron
#   dsigmv: derivada da funcao sigmoide avaliada no campo induzido do perceptron
#
# Autor
# =====
#
# Eduardo Vasconcelos
# <eduardovasconcelos@usp.br>
#

function [y dsigmv] = perceptron(w, x, a, f)

    v = sum(w .* x);
    
    # Nota: A funcao sign do Octave retorna 0 para argumento 0, portanto
    # nao eh possivel usar a linha
    #y = sign(sum(w .* x));
    if (!ismember({'a'}, who)) # Sinal
        if (v >= 0)
            y = 1;
        else
            y = -1;
        end
    elseif (!ismember({'f'}, who) || strcmp(f, 'tanh') == 1) # Tangente hiperbolica
        y = tanh(a*v/2);
        dsigmv = 0.5*a*sech(a*v/2)^2;
    elseif (strcmp(f, 'logi') == 1) # Logistica
        y = 1/(1 + exp(-a*v));
        dsigmv = a*exp(v)/((exp(a*v) + 1)^2);
    end

end
