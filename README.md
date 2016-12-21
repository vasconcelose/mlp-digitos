# mlp-digitos

Implementacao de rede neural MLP para reconhecimento de digitos.

## LICENCA

Copyright (c) 2016 Eduardo Santos Medeiros de Vasconcelos

Permission is hereby granted, free of charge, to any person obtaining 
a copy of this software and associated documentation files (the 
“Software”), to deal in the Software without restriction, including 
without limitation the rights to use, copy, modify, merge, publish, 
distribute, sublicense, and/or sell copies of the Software, and to 
permit persons to whom the Software is furnished to do so, subject to 
the following conditions:

The above copyright notice and this permission notice shall be included 
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS 
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## AUTOR

Eduardo S. M. de Vasconcelos | eduardovasconcelos@usp.br
<br>NUSP 7656724 | Universidade de Sao Paulo
<br>Escola de Engenharia de Sao Carlos &
Instituto de Ciencias Matematicas e de Computacao

## GUIA

Esta secao descreve a utilizacao basica desta implementacao de
Multilayer perceptron (MLP). Vide relatorio de projeto em
"RelatorioProjeto1RedesNeuraisEduardoVasconcelos.pdf" para mais
informacao a respeito deste projeto.

Este trabalho foi desenvolvido em Octave. Para executa-lo eh necessario
que o Octave esteja devidamente instalado no seu computador.

### Como treinar uma rede MLP utilizando esta implementacao?

Para treinar uma rede MLP eh preciso chamar mlp.m como abaixo. Observe
que ha uma barra ('/') apos o nome do diretorio onde estao os arquivos
de treinamento.

$ octave mlp.m --treina <nome do diretorio contendo arquivos de exemplos>/ <tipo de arquivo dos exemplos>
e.g. $ octave mlp.m --treina train_ascii/ txt
     $ octave mlp.m --treina train_bmp/ bmp

Esta chamada cria dois arquivos de saida, a saber:
em.png -> grafico do erro quadratico medio por epoca da rede
mlpobj.txt -> arquivo txt de serializacao de objeto do octave contendo um
    objeto MLPObj, necessario para testar a rede treinada. Este arquivo contem
    os pesos calculados (w), os parametros da rede (n, a, alfa, arq, N, e), as saidas
    da rede (y) para os vetores de treinamento, a seed (seed) utilizada no treinamento
    e as colunas inuteis (colsElim) eliminadas da matriz de treinamento, a serem
    igualmente eliminadas da matriz de teste quando do teste da rede MLP.

### Como testar uma rede MLP ja treinada utilizando esta implementacao?

Antes de testar uma MLP eh preciso que ela tenha sido devidamente treinada.
Deve existir um arquivo txt de objeto MLPObj devidamente serializado (o
treinamento faz isso automaticamente). Para testar uma rede MLP eh preciso
chamar mlp.m como abaixo. Observe que ha uma barra ('/') apos o nome do
diretorio onde estao os arquivos de teste.

$ octave mlp.m --testa <nome do diretorio contendo arquivos de teste>/ <tipo de arquivo dos testes> <arquivo de objeto MLP>
e.g. $ octave mlp.m --testa test_ascii_10/ txt mlpobj.txt
     $ octave mlp.m --testa test_bmp_10/ bmp mlpobj.txt

Esta chamada cria o arquivo resultados.txt, que contem as saidas (y) da rede a
cada vetor de teste, a distancia cartesiana (dist) de cada saida da rede a
uma saida valida e ainda as respostas finais da rede (resposta) a cada vetor de
teste, calculadas a partir das distancias em "dist".

### Como modificar os parametros da MLP?

Os parametros da MLP (n, a, alfa, arq, N, e) podem ser modificados no comeco do arquivo mlp.m.
Cada parametro esta identificado por um comentario em mlp.m.
