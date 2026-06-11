################################################################################
#
# INTRODUÇÃO AO R APLICADO À ECONOMETRIA I
#
# ROTEIRO PRÁTICO DO ALUNO
#
# Complete os códigos durante a aula.
#
# Fluxo:
# pergunta -> dados -> tratamento -> estatísticas -> gráficos -> regressão -> interpretação
#
# Pergunta da aula:
# Municípios com melhores condições socioeconômicas e escolares apresentam
# melhores indicadores educacionais?
#
################################################################################


# ==============================================================================
# 0. PREPARANDO O AMBIENTE
# ==============================================================================

# Abra o arquivo .Rproj da aula.
# Confira se existe uma pasta chamada dados.

# Carregue o pacote tidyverse:




# ==============================================================================
# 1. PRIMEIROS PASSOS COM O R
# ==============================================================================

# Faça algumas operações matemáticas:




# Crie um objeto x recebendo o valor 10:




# Veja o objeto x:




# Use o objeto x em algumas operações:




# Crie um objeto chamado media_turma:




# ==============================================================================
# 2. CLASSES DE OBJETOS
# ==============================================================================

# Crie um número e veja sua classe:




# Crie um texto e veja sua classe:




# Crie um valor lógico e veja sua classe:




# ==============================================================================
# 3. IMPORTANDO BASES DE DADOS
# ==============================================================================

# Bases utilizadas:
#
# ideb.csv
# indicadores.csv
# pib.csv

# Importe a base do IDEB:




# Importe a base de indicadores:




# Importe a base do PIB:




# ==============================================================================
# 4. CONHECENDO AS BASES
# ==============================================================================

# Antes de qualquer análise, precisamos olhar os dados.
# Nunca comece uma regressão sem antes entender a base.

# Veja as primeiras linhas:




# Abra as bases:




# Veja a estrutura:




# Veja estatísticas básicas:




# Veja dimensões, número de linhas e colunas:




# Veja os nomes das variáveis:




# Perguntas:
#
# O que representa uma linha da base do IDEB?
#
# O que representa uma linha da base de indicadores?
#
# O que representa uma linha da base do PIB?
#
# As três bases possuem a mesma unidade de observação?
#
# Qual é a chave para juntar as bases educacionais?
#
# Qual é a chave para juntar a base do PIB?
#
# Resposta:




# ==============================================================================
# 5. MANIPULAÇÃO DE DADOS COM DPLYR
# ==============================================================================

# Na prática, quase nunca usamos uma base exatamente como ela veio.
# Normalmente precisamos selecionar variáveis, filtrar observações,
# criar novas colunas, resumir informações e juntar bases.


# ------------------------------------------------------------------------------
# SELECT()
# ------------------------------------------------------------------------------

# Crie uma base ideb2 com:
#
# ano
# id_municipio
# rede
# etapa
# ideb




# Veja as primeiras linhas de ideb2:




# ------------------------------------------------------------------------------
# FILTER()
# ------------------------------------------------------------------------------

# Filtre observações com IDEB maior que 7:




# Filtre apenas EF anos iniciais:




# Filtre apenas rede municipal:




# Combine filtros:
# rede municipal + EF anos iniciais




# ------------------------------------------------------------------------------
# MUTATE()
# ------------------------------------------------------------------------------

# mutate() cria novas colunas ou altera colunas existentes.

# Veja a estrutura da base pib:




# Tente criar pib_pc_mil antes de criar pib_pc.
# O que acontece?




# Resposta:
#
#


# Agora crie:
#
# pib_pc      = PIB dividido pela população
# pib_pc_mil  = PIB per capita em milhares de reais




# Veja a base pib após a criação das variáveis:




# Crie o log do PIB per capita:




# Crie grupos acima e abaixo da mediana do PIB per capita:




# Conte quantos municípios existem em cada grupo:




# ------------------------------------------------------------------------------
# ARRANGE()
# ------------------------------------------------------------------------------

# arrange() ordena a base.

# Ordene os maiores valores de IDEB:




# Ordene os menores valores de IDEB:




# ------------------------------------------------------------------------------
# COUNT()
# ------------------------------------------------------------------------------

# count() conta observações por grupo.

# Conte observações por rede:




# Conte observações por rede e etapa:




# Conte observações com IDEB não ausente por rede e etapa:




# ------------------------------------------------------------------------------
# SUMMARISE()
# ------------------------------------------------------------------------------

# summarise() calcula estatísticas resumidas.

# Calcule média, desvio padrão, mínimo e máximo do IDEB sem usar na.rm:




# O que aconteceu?
#
# Resposta:




# Agora repita usando na.rm = TRUE:




# O que significa na.rm = TRUE?
#
# Resposta:




# ------------------------------------------------------------------------------
# GROUP_BY() + SUMMARISE()
# ------------------------------------------------------------------------------

# group_by() permite calcular estatísticas por grupos.

# Calcule o IDEB médio por rede:




# Calcule o IDEB médio por etapa:




# Calcule o IDEB médio por rede e etapa:




# Calcule indicadores médios por rede e etapa:




# Perguntas:
#
# O IDEB médio parece diferente entre redes?
#
# Qual etapa apresenta maior taxa de abandono?
#
# Essas diferenças significam causalidade?
#
# Resposta:




# ==============================================================================
# 6. JUNTANDO BASES DE DADOS
# ==============================================================================

# Em Economia, as informações frequentemente vêm de bases diferentes.
# Para estimar um modelo, precisamos juntar essas informações em uma base final.

# As bases educacionais possuem a mesma chave:
# ano, id_municipio, rede e etapa.
#
# A base do PIB está no nível do município.
# Por isso, ela será juntada usando id_municipio.

# Confira se existem duplicatas nas chaves das bases educacionais:




# Confira se existem duplicatas na chave da base do PIB:




# Faça o left_join:
#
# ideb + indicadores + pib




# Confira a base final:




# ==============================================================================
# 7. ANÁLISE EXPLORATÓRIA
# ==============================================================================

# Antes de estimar modelos, devemos explorar os dados.

# Calcule estatísticas médias das principais variáveis:




# Faça estatísticas por rede e etapa:




# Verifique valores ausentes por variável:




# Verifique valores ausentes nas principais variáveis da análise:




# Crie a base dados_modelo sem valores ausentes nas variáveis principais:
#
# ideb
# log_pib
# tdi
# hrs_aula




# Compare o número de observações antes e depois:




# Calcule a correlação entre IDEB e log do PIB:




# Calcule correlações por etapa:




# O que uma correlação mede?
#
# Resposta:




# Correlação indica causalidade?
#
# Resposta:




# ==============================================================================
# 8. VISUALIZAÇÃO COM GGPLOT2
# ==============================================================================

# Gráficos ajudam a entender os dados antes da regressão.


# ------------------------------------------------------------------------------
# Histograma do IDEB
# ------------------------------------------------------------------------------

# Faça um histograma do IDEB:




# O que o histograma mostra?
#
# Resposta:




# ------------------------------------------------------------------------------
# Boxplot do IDEB por etapa
# ------------------------------------------------------------------------------

# Faça um boxplot do IDEB por etapa:




# O que o boxplot permite comparar?
#
# Resposta:




# ------------------------------------------------------------------------------
# Dispersão: log do PIB per capita x IDEB
# ------------------------------------------------------------------------------

# Faça um gráfico de dispersão:
#
# x = log_pib
# y = ideb




# Agora adicione uma reta de regressão:




# O gráfico indica causalidade?
#
# Resposta:




# ==============================================================================
# 9. REGRESSÃO LINEAR SIMPLES
# ==============================================================================

# Modelo geral:
#
# Y_i = beta0 + beta1 X_i + u_i
#
# A regressão simples relaciona uma variável dependente Y
# com uma variável explicativa X.


# ------------------------------------------------------------------------------
# Modelo 1: IDEB e PIB per capita
# ------------------------------------------------------------------------------

# Modelo:
#
# IDEB = beta0 + beta1 log(PIB per capita) + erro

# Estime o modelo:




# Veja os resultados:




# Interprete:
#
# Qual é o sinal do coeficiente de log_pib?
#
# Ele é estatisticamente significativo?
#
# Podemos interpretar como causalidade?
#
# Resposta:




# ------------------------------------------------------------------------------
# Modelo 2: IDEB e distorção idade-série
# ------------------------------------------------------------------------------

# Modelo:
#
# IDEB = beta0 + beta1 TDI + erro

# Estime o modelo:




# Veja os resultados:




# Interprete o coeficiente de TDI:
#
# Resposta:




# ==============================================================================
# 10. REGRESSÃO MÚLTIPLA
# ==============================================================================

# Na prática, o desempenho educacional não está associado a apenas uma variável.
# Podemos incluir mais variáveis no modelo.

# Modelo:
#
# IDEB = beta0 + beta1 log_pib + beta2 tdi + beta3 hrs_aula + erro
#
# Não usamos taxa de aprovação porque ela faz parte da construção do IDEB.

# Estime o modelo múltiplo com:
#
# log_pib
# tdi
# hrs_aula




# Veja os resultados:




# O que significa interpretação ceteris paribus?
#
# Resposta:




# ==============================================================================
# 11. VARIÁVEIS CATEGÓRICAS
# ==============================================================================

# Como a base tem rede e etapa, podemos incluir essas variáveis no modelo.
# O R cria automaticamente dummies para variáveis de texto ou fator.

# Inclua rede e etapa no modelo:
#
# ideb ~ log_pib + tdi + hrs_aula + rede + etapa




# Veja os resultados:




# Como o R trata variáveis categóricas?
#
# Resposta:




# Qual é a categoria de referência?
#
# Resposta:




# ==============================================================================
# 12. COMPARANDO MODELOS
# ==============================================================================

# Compare os modelos estimados:




# Perguntas:
#
# O sinal dos coeficientes faz sentido?
#
# Os coeficientes são estatisticamente significativos?
#
# O R² aumentou quando adicionamos mais variáveis?
#
# O que acontece com os coeficientes quando adicionamos controles?
#
# Podemos interpretar os resultados como causais?
#
# Resposta:




# ==============================================================================
# 13. EXPORTANDO RESULTADOS
# ==============================================================================

# Crie uma pasta resultados caso ela não exista:




# Exporte a base final:




# Exporte uma tabela resumida, se quiser:




################################################################################
#
# FIM
#
# Você passou por todas as etapas de uma análise aplicada:
#
# dados -> tratamento -> estatísticas -> gráficos -> regressão -> interpretação
#
# Ideia principal:
# R não é apenas uma calculadora. É uma ferramenta para organizar, documentar
# e reproduzir análises empíricas.
#
################################################################################
