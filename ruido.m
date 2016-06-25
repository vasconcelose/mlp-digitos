# ruido.m
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
# Script auxiliar. Acrescenta ruido as entradas de treinamento da MLP para testes
#
# Uso: $ octave ruido.m <diretorio dos arquivos de treinamento> <tipo de arquivo>>
#   e.g. $ octave ruido.m train_ascii txt
#
# Autor
# =====
#
# Eduardo Vasconcelos
# <eduardovasconcelos@usp.br>
#

args = argv;
dirIn = args{1};

niveis = [ 0.1 0.2 0.3 ]; # Porcentagens de ruido

for n = niveis
    dirOut = strcat(strrep(dirIn, 'train', 'test'), '_', num2str(n*100));
    mkdir(dirOut);
    
    for lista = ls(dirIn)'
        if (strcmp(args{2}, 'txt') == 1)
        
            arquivo = fopen(strcat(dirIn, '/', lista(:)'));
            txt = fread(arquivo);
            total = length(txt);
            fclose(arquivo);
            
            for d = 1:round(total*n)
                p = 0;
                while(p == 0 || mod(p, 9) == 0)
                    p = round(rand(1)*total);
                end
                txt(p) = 64;
            end
            
            novoArquivo = fopen(strcat(dirOut, '/', lista(:)'), 'w');
            fwrite(novoArquivo, txt);
            fclose(novoArquivo);
            
        else # argv{2} == 'bmp'
            
            imagem = imread(strcat(dirIn, '/', lista(:)'));
            
            for d = 1:round(rows(imagem)*columns(imagem)*n)
                i = 0;
                j = 0;
                while(i == 0 || j == 0)
                    i = round(rand(1)*rows(imagem));
                    j = round(rand(1)*columns(imagem));
                end
                imagem(i,j) = 0;
            end
            
            imwrite(imagem, strcat(dirOut, '/', lista(:)'));
            
        end
    end
end
