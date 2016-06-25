# mlp.m
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
# Implementacao de rede MLP para reconhecimento de digitos a partir de arquivos de
# texto com ASCII Art ou imagens BMP com fundo branco e fonte preta
#
# Guia rapido de utilizacao
# =========================
#
# 1) Treinamento
#   $ octave mlp.m --treina <nome do diretorio contendo arquivos de exemplos>/ \
#<tipo de arquivo dos exemplos>
#   e.g. $ octave mlp.m --treina train_ascii/ txt
#
# 2) Teste
#   $ octave mlp.m --testa <nome do diretorio contendo arquivos de teste>/ \
#<tipo de arquivo dos testes> <arquivo de objeto MLP>
#   e.g. $ octave mlp.m --testa test_ascii_10/ txt resultados/ascii/mlpObj.txt
#
# Autor
# =====
#
# Eduardo Vasconcelos
# <eduardovasconcelos@usp.br>
#

clear all
clc
warning('off', 'all')
args = argv;

#
# Constantes
#
n = 0.5; # Taxa de aprendizado
a = 0.5; # Parametro a da sigmoide
alfa = 0.5; # Parametro de momentum
arq = [ 20 4 ]; # Arquitetura da rede (no. de neuronios em cada camada)
N = 10000; # No. maximo de epocas de treinamento
e = 10E-3; # Erro quadratico medio admissivel

# Fundo dos arquivos de entrada
if (strcmp(args{3}, 'txt') == 1)
    background = 46; # Fundo preenchido com pontos (valor ASCII 46)
else
    background = 0; # Fundo na cor preta
end

# Saidas esperadas para cada linha correspondente
# de x (esta em codigo Gray)
d = [
    -1 -1 -1 -1;
    -1 -1 -1  1;
    -1 -1  1  1;
    -1 -1  1 -1;
    -1  1  1 -1;
    -1  1  1  1;
    -1  1 -1  1;
    -1  1 -1 -1;
     1  1 -1 -1;
     1  1 -1  1;
];

#
# Definicao de modo de operacao
#
if (strcmp(args{1}, "--treina") == 1)

    dirTreinamento = args{2};
    
    if (strcmp(args{3}, 'txt') == 1)
        rand('seed', 4.040279993523486e-311); # Seed que teve boa performance para txt
    else # args{3} == 'bmp'
        rand('seed', 1.773988484532379e-310); # Seed que teve boa performance para bmp
    end

    #
    # Leitura dos arquivos de entrada
    #

    # Conjunto de treinamento
    x = [];

    # Valores brutos lidos a partir dos arquivos de treinamento
    xArq = [];

    # Leitura de vetores de treinamento
    for nome = ls(dirTreinamento)'
        if (strcmp(args{3}, 'txt') == 1)
            txt = fopen(strcat(dirTreinamento, nome(:)'));

            nLinhas = fskipl(txt, Inf) + 1;
            frewind(txt);
            instancia = [];
            for i = 1:nLinhas
                linha = fgetl(txt);
                instancia = [ instancia; linha ];
            end
            fclose(txt);
        else # args{3} == 'bmp'
            instancia = imread(strcat(dirTreinamento, nome(:)'));
            
            # Debug
            #imshow(instancia)
            #pause
            
        end
        xArq = [ xArq; 1 reshape(instancia, 1, numel(instancia)) ]; # Linearizar matriz de entrada
    end

    # Mapeamento de xArq para x (x deve ter apenas valores 1 ou -1)
    for i = 1:size(xArq)(1)
        for j = 1:size(xArq)(2)
            if (xArq(i,j) == background)
                x(i,j) = -1;
            else
                x(i,j) = 1;
            end
        end
    end

    # Varredura para eliminar informacao desnecessaria (i.e. colunas
    # que sao iguais para todas as instancias de entrada)
    nCols = size(x)(2);
    i = 2;
    colsElim = [];
    while(i < nCols)
        if (abs(sum(x(:,i))) == size(x)(1))
            x = [ x(:,1:i-1) x(:,i+1:end) ];
            nCols = nCols - 1;
            colsElim = [ colsElim i ];
        else
            i++;
        end
    end

    #
    # Fase de treinamento
    #

    # Treinamento da rede MLP
    
    # Debug
    #s = rand('seed');
    #save seed.txt s;

    [w em] = treinamlp(n, x, d, arq, N, a, e, alfa);

    # Teste com os proprios exemplos de treinamento
    y=[];
    for i = 1:size(x)(1)
        tmp = classificaentrada(w, x(i,:), arq, a);
        y = [ y; tmp{length(arq)} ];
    end

    #
    # Saidas
    #

    # Salvar grafico de erro
    plot(em, "r-");
    xlabel("n");
    ylabel("em");
    print -dpng em.png; # Grafico de erro
    
    # Serializar objeto MLP
    MLPObj.n = n;
    MLPObj.a = a;
    MLPObj.alfa = alfa;
    MLPObj.arq = arq;
    MLPObj.N = N;
    MLPObj.e = e;
    MLPObj.seed = rand('seed');
    MLPObj.colsElim = colsElim; # Colunas de entrada eliminadas
    MLPObj.w = w; # Pesos
    MLPObj.y = y; # Saidas
    
    save mlpobj.txt MLPObj;

else # args{1} == '--testa'

    #
    # Fase de configuracao
    #

    dirTeste = args{2}; # Diretorio de arquivos de teste

    # Carregar objeto MLP
    MLPObj = struct();
    load('-text', args{4}, 'MLPObj');

    #
    # Fase de leitura de vetores de teste
    #

    # Conjunto de teste
    x = [];

    # Valores brutos lidos a partir dos arquivos de teste
    xArq = [];

    # Leitura de vetores de teste
    for nome = ls(dirTeste)'
        if (strcmp(args{3}, 'txt') == 1)
            txt = fopen(strcat(dirTeste, nome(:)'));

            nLinhas = fskipl(txt, Inf) + 1;
            frewind(txt);
            instancia = [];
            for i = 1:nLinhas
                linha = fgetl(txt);
                instancia = [ instancia; linha ];
            end
            fclose(txt);
        else # args{3} == 'bmp'
            instancia = imread(strcat(dirTeste, nome(:)'));
            
            # Debug
            #imshow(instancia)
            #pause
            
        end
        xArq = [ xArq; 1 reshape(instancia, 1, numel(instancia)) ]; # Linearizar matriz de entrada
    end

    # Mapeamento de xArq para x (x deve ter apenas valores 1 ou -1)
    for i = 1:size(xArq)(1)
        for j = 1:size(xArq)(2)
            if (xArq(i,j) == background)
                x(i,j) = -1;
            else
                x(i,j) = 1;
            end
        end
    end

    # Varredura para eliminar colunas cortadas no treinamento
    nCols = size(x)(2);
    i = 2;
    for c = MLPObj.colsElim
        x = [ x(:,1:c-1) x(:,c+1:end) ];
    end
    
    #
    # Fase de teste
    #
    
    y=[];
    for i = 1:size(x)(1)
        clc
        printf("Testando vetor %d/%d\n", i, size(x)(1));
        tmp = classificaentrada(MLPObj.w, x(i,:), MLPObj.arq, MLPObj.a);
        y = [ y; tmp{length(MLPObj.arq)} ];
    end

    # Distancia cartesiana entre saidas obtidas e saidas esperadas
    dist = {};
    for j = 1:size(d)(1)
        for i = 1:size(y)(1)
            dist{i}(j) = sqrt(sum( (y(i,:) .- d(j,:)).^2 ));
        end
    end
    
    # Pesquisa de resposta a partir das distancias cartesianas
    resposta = [];
    for i = 1:size(y)(1)
        [ menor, iMenor ] = min(dist{i});
        resposta = [ resposta; iMenor - 1 ];
    end

    #
    # Saida do teste
    #
    
    Resultados.y = y;
    Resultados.dist = dist;
    Resultados.resposta = resposta;
    save resultados.txt Resultados;

end
