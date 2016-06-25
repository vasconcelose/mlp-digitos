# classificamlp.m
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
# Calcula saida completa (todas as camadas) de rede MLP usando
# o perceptron com funcao de saida sigmoide
#
# Entradas:
#   w: cell de pesos da rede
#   x: entrada cuja saida sera calculada
#   arq: arquitetura da rede (formato descrito em treinamlp.m)
#   a: parametro a da sigmoide utilizada
#
# Saidas:
#   y: cell de saidas da rede
#   dsigmv: cell de derivada da funcao sigmoide avaliada no campo induzido por cada neuronio
#
# Autor
# =====
#
# Eduardo Vasconcelos
# <eduardovasconcelos@usp.br>
#
function [y dsigmv] = classificaentrada(w, x, arq, a)

y = {}; # A saida de cada camada eh um elemento da cell
dsigmv = {}; # Derivada da sigmoide avaliada no campo induzido por cada neuronio

for i = 1:size(arq)(2) # Para cada camada da arquitetura, a comecar pela entrada
    y{i} = [];
    dsigmv{i} = [];
    for j = 1:arq(i) # Para cada neuronio que recebe sinal na proxima camada
        [yp dsigmvp] = perceptron(w{i}(:,j)', x, a);
        y{i} = [y{i} yp];
        dsigmv{i} = [dsigmv{i} dsigmvp];
    end
    x = y{i}; # A entrada da proxima camada eh a saida da anterior
end

end
