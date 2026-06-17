################################################################################
#
# INTRODUÇÃO AO R APLICADO À ECONOMETRIA I
#
# ROTEIRO PRÁTICO RESOLVIDO
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
# ===============================================================================

# Abra o arquivo .Rproj da aula.
# Confira se existe uma pasta chamada dados.

# Carregue o pacote tidyverse:

library(tidyverse)

# Observação:
# O tidyverse reúne funções úteis para importar, organizar, transformar e
# visualizar dados. As mensagens de conflito com filter() e lag() são normais.


# ==============================================================================
# 1. PRIMEIROS PASSOS COM O R
# ===============================================================================

# Faça algumas operações matemáticas:

2 + 2
10 - 5
5 * 3
10 / 2

# Crie um objeto x recebendo o valor 10:

x <- 10

# Veja o objeto x:

x

# Use o objeto x em algumas operações:

x + 5
x * 2

# Crie um objeto chamado media_turma:

media_turma <- 8.5
media_turma

# Observação:
# O R pode ser usado como calculadora, mas também permite guardar valores em
# objetos para reutilizá-los em outros comandos.


# ==============================================================================
# 2. CLASSES DE OBJETOS
# ===============================================================================

# Crie um número e veja sua classe:

idade <- 25
class(idade)

# Crie um texto e veja sua classe:

curso <- "Economia"
class(curso)

# Crie um valor lógico e veja sua classe:

aprovado <- TRUE
class(aprovado)

# Observação:
# Valores numéricos permitem operações matemáticas; textos ficam entre aspas;
# valores lógicos assumem TRUE ou FALSE.


# ==============================================================================
# 3. IMPORTANDO BASES DE DADOS
# ===============================================================================

# Bases utilizadas:
# ideb.csv
# indicadores.csv
# pib.csv

# Importe a base do IDEB:

ideb <- read_csv("dados/ideb.csv")

# Importe a base de indicadores:

indicadores <- read_csv("dados/indicadores.csv")

# Importe a base do PIB:

pib <- read_csv("dados/pib.csv")


# ==============================================================================
# 4. CONHECENDO AS BASES
# ===============================================================================

# Antes de qualquer análise, precisamos olhar os dados.
# Nunca comece uma regressão sem antes entender a base.

# Veja as primeiras linhas:

head(ideb)
head(indicadores)
head(pib)

# Abra as bases:

View(ideb)
View(indicadores)
View(pib)

# Veja a estrutura:

glimpse(ideb)
glimpse(indicadores)
glimpse(pib)

# Veja estatísticas básicas:

summary(ideb)
summary(indicadores)
summary(pib)

# Veja dimensões, número de linhas e colunas:

dim(ideb)
dim(indicadores)
dim(pib)

nrow(ideb)
nrow(indicadores)
nrow(pib)

ncol(ideb)
ncol(indicadores)
ncol(pib)

# Veja os nomes das variáveis:

names(ideb)
names(indicadores)
names(pib)

# Perguntas e respostas:
#
# O que representa uma linha da base do IDEB?
# Resposta: uma combinação de ano, município, rede e etapa.
#
# O que representa uma linha da base de indicadores?
# Resposta: uma combinação de ano, município, rede e etapa.
#
# O que representa uma linha da base do PIB?
# Resposta: uma observação por município.
#
# As três bases possuem a mesma unidade de observação?
# Resposta: não. IDEB e indicadores estão no nível ano-município-rede-etapa;
# a base do PIB está no nível do município.
#
# Qual é a chave para juntar as bases educacionais?
# Resposta: ano, id_municipio, rede e etapa.
#
# Qual é a chave para juntar a base do PIB?
# Resposta: id_municipio.


# ==============================================================================
# 5. MANIPULAÇÃO DE DADOS COM DPLYR
# ===============================================================================

# Na prática, quase nunca usamos uma base exatamente como ela veio.
# Normalmente precisamos selecionar variáveis, filtrar observações,
# criar novas colunas, resumir informações e juntar bases.


# ------------------------------------------------------------------------------
# SELECT()
# ------------------------------------------------------------------------------

# Crie uma base ideb2 com:
# id_municipio, rede, etapa e ideb.

ideb2 <- ideb |>
  select(
    id_municipio,
    rede,
    etapa,
    ideb
  )

# Veja as primeiras linhas de ideb2:

head(ideb2)


# ------------------------------------------------------------------------------
# FILTER()
# ------------------------------------------------------------------------------

# Filtre observações com IDEB maior que 7:

ideb |>
  filter(ideb > 7)

# Filtre apenas EF anos iniciais:

ideb |>
  filter(etapa == "EF anos iniciais")

# Filtre apenas rede municipal:

ideb |>
  filter(rede == "municipal")

# Combine filtros:
# rede municipal + EF anos iniciais

ideb |>
  filter(
    rede == "municipal",
    etapa == "EF anos iniciais"
  )


# ------------------------------------------------------------------------------
# MUTATE()
# ------------------------------------------------------------------------------

# mutate() cria novas colunas ou altera colunas existentes.

# Veja a estrutura da base pib:

glimpse(pib)

# Tente criar pib_pc_mil antes de criar pib_pc.
# O que acontece?

pib |>
  mutate(
    pib_pc_mil = pib_pc / 1000
  )

# Resposta:
# O R retorna erro porque a variável pib_pc ainda não existe na base.
# Primeiro precisamos criar pib_pc a partir de pib e populacao.

# Agora crie:
# pib_pc      = PIB dividido pela população
# pib_pc_mil  = PIB per capita em milhares de reais

pib <- pib |>
  mutate(
    pib_pc = pib / populacao,
    pib_pc_mil = pib_pc / 1000
  )

# Veja a base pib após a criação das variáveis:

head(pib)

# Crie o log do PIB per capita:

pib <- pib |>
  mutate(
    log_pib = log(pib_pc)
  )

# Comentário:
# A função log() calcula o logaritmo natural (ln).

# No R:

# log(x)   -> logaritmo natural (base e)
# log10(x) -> logaritmo na base 10
# log2(x)  -> logaritmo na base 2

# Em economia e econometria, quando usamos uma variável em "log",
# geralmente estamos nos referindo ao logaritmo natural.

# A transformação em log é muito utilizada em variáveis econômicas,
# como renda, salários e PIB, porque reduz diferenças muito grandes
# entre observações e facilita a interpretação dos coeficientes.

# Neste caso:

# log_pib = logaritmo natural do PIB per capita.

# Crie grupos acima e abaixo da mediana do PIB per capita:

pib <- pib |>
  mutate(
    grupo_pib = if_else(
      pib_pc >= median(pib_pc, na.rm = TRUE),
      "Acima da mediana",
      "Abaixo da mediana"
    )
  )

# Conte quantos municípios existem em cada grupo:

pib |>
  count(grupo_pib)


# ------------------------------------------------------------------------------
# ARRANGE()
# ------------------------------------------------------------------------------

# arrange() ordena a base.

# Ordene os maiores valores de IDEB:

ideb |>
  arrange(desc(ideb))

# Ordene os menores valores de IDEB:

ideb |>
  arrange(ideb)


# ------------------------------------------------------------------------------
# COUNT()
# ------------------------------------------------------------------------------

# count() conta observações por grupo.

# Conte observações por rede:

ideb |>
  count(rede)

# Conte observações por rede e etapa:

ideb |>
  count(rede, etapa)

# Conte observações com IDEB não ausente por rede e etapa:

ideb |>
  filter(!is.na(ideb)) |>
  count(rede, etapa)

# Comentário:
# A função is.na() verifica se existem valores ausentes (NA).

# O símbolo ! significa "não" ou "negação".

# Portanto:

# is.na(ideb)  -> seleciona observações em que o IDEB é ausente.
# !is.na(ideb) -> seleciona observações em que o IDEB NÃO é ausente.

# Neste caso, filtramos apenas as linhas com IDEB disponível
# antes de contar as observações por rede e etapa.


# ------------------------------------------------------------------------------
# SUMMARISE()
# ------------------------------------------------------------------------------

# summarise() calcula estatísticas resumidas.

# Calcule média, desvio padrão, mínimo e máximo do IDEB sem usar na.rm:

ideb |>
  summarise(
    media_ideb = mean(ideb),
    desvio_ideb = sd(ideb),
    minimo_ideb = min(ideb),
    maximo_ideb = max(ideb)
  )

# O que aconteceu?
# Resposta: o resultado aparece como NA porque existem valores ausentes.
# Por padrão, mean(), sd(), min() e max() não ignoram valores NA.

# Agora repita usando na.rm = TRUE:

ideb |>
  summarise(
    media_ideb = mean(ideb, na.rm = TRUE),
    desvio_ideb = sd(ideb, na.rm = TRUE),
    minimo_ideb = min(ideb, na.rm = TRUE),
    maximo_ideb = max(ideb, na.rm = TRUE)
  )

# O que significa na.rm = TRUE?
# Resposta: significa remover/ignorar os valores NA antes de calcular a estatística.


# ------------------------------------------------------------------------------
# GROUP_BY() + SUMMARISE()
# ------------------------------------------------------------------------------

# group_by() permite calcular estatísticas por grupos.

# Calcule o IDEB médio por rede:

ideb_rede <- ideb |>
  group_by(rede) |>
  summarise(
    media_ideb = mean(ideb, na.rm = TRUE),
    desvio_ideb = sd(ideb, na.rm = TRUE),
    n_com_ideb = sum(!is.na(ideb)),
    .groups = "drop"
  )

ideb_rede

# Calcule o IDEB médio por etapa:

ideb_etapa <- ideb |>
  group_by(etapa) |>
  summarise(
    media_ideb = mean(ideb, na.rm = TRUE),
    desvio_ideb = sd(ideb, na.rm = TRUE),
    n_com_ideb = sum(!is.na(ideb)),
    .groups = "drop"
  )

ideb_etapa

# Comentário:
# O group_by() cria grupos dentro da base.
# Nesse caso, os cálculos são feitos separadamente
# para cada etapa de ensino.

# O summarise() retorna uma tabela resumida com uma linha por grupo.

# O argumento .groups = "drop" remove o agrupamento após o cálculo,
# fazendo com que o resultado volte a ser uma base sem grupos.


# Calcule o IDEB médio por rede e etapa:

ideb_rede_etapa <- ideb |>
  group_by(rede, etapa) |>
  summarise(
    media_ideb = mean(ideb, na.rm = TRUE),
    desvio_ideb = sd(ideb, na.rm = TRUE),
    n_com_ideb = sum(!is.na(ideb)),
    .groups = "drop"
  ) |>
  arrange(etapa, rede)

ideb_rede_etapa

# Calcule indicadores médios por rede e etapa:

indicadores_rede_etapa <- indicadores |>
  group_by(rede, etapa) |>
  summarise(
    media_tdi = mean(tdi, na.rm = TRUE),
    media_aprovacao = mean(taxa_aprovacao, na.rm = TRUE),
    media_reprovacao = mean(taxa_reprovacao, na.rm = TRUE),
    media_abandono = mean(taxa_abandono, na.rm = TRUE),
    media_horas_aula = mean(hrs_aula, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(etapa, rede)

indicadores_rede_etapa

# Perguntas e respostas:
#
# O IDEB médio parece diferente entre redes?
# Resposta: sim. As médias variam entre redes, mas a comparação é descritiva.
#
# Qual etapa apresenta maior taxa de abandono?
# Resposta: verificar na tabela indicadores_rede_etapa.
#
# Essas diferenças significam causalidade?
# Resposta: não. Diferenças de médias mostram associação/descritivas, não efeito causal.


# ==============================================================================
# 6. JUNTANDO BASES DE DADOS
# ===============================================================================

# As bases educacionais possuem a mesma chave:
# ano, id_municipio, rede e etapa.
# A base do PIB está no nível do município e será juntada por id_municipio.

# Confira se existem duplicatas nas chaves das bases educacionais:

ideb |>
  count(ano, id_municipio, rede, etapa) |>
  filter(n > 1)

indicadores |>
  count(ano, id_municipio, rede, etapa) |>
  filter(n > 1)

# Confira se existem duplicatas na chave da base do PIB:

pib |>
  count(id_municipio) |>
  filter(n > 1)

# Faça o left_join:
# ideb + indicadores + pib

dados <- ideb |>
  left_join(
    indicadores,
    by = c("ano", "id_municipio", "rede", "etapa")
  ) |>
  left_join(
    pib,
    by = "id_municipio"
  )

# Confira a base final:

glimpse(dados)
head(dados)
summary(dados)

# Observação:
# O left_join mantém todas as observações da base de IDEB e adiciona as
# informações disponíveis nas outras bases.


# ==============================================================================
# 7. ANÁLISE EXPLORATÓRIA
# ===============================================================================

# Antes de estimar modelos, devemos explorar os dados.

# Calcule estatísticas médias das principais variáveis:

dados |>
  summarise(
    media_ideb = mean(ideb, na.rm = TRUE),
    media_tdi = mean(tdi, na.rm = TRUE),
    media_aprovacao = mean(taxa_aprovacao, na.rm = TRUE),
    media_reprovacao = mean(taxa_reprovacao, na.rm = TRUE),
    media_abandono = mean(taxa_abandono, na.rm = TRUE),
    media_horas_aula = mean(hrs_aula, na.rm = TRUE),
    media_pib_pc = mean(pib_pc, na.rm = TRUE)
  )

# Faça estatísticas por rede e etapa:

dados |>
  group_by(rede, etapa) |>
  summarise(
    media_ideb = mean(ideb, na.rm = TRUE),
    media_tdi = mean(tdi, na.rm = TRUE),
    media_aprovacao = mean(taxa_aprovacao, na.rm = TRUE),
    media_abandono = mean(taxa_abandono, na.rm = TRUE),
    media_pib_pc = mean(pib_pc, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) |>
  arrange(etapa, rede)

# Verifique valores ausentes por variável:

colSums(is.na(dados))

# Verifique valores ausentes nas principais variáveis da análise:

dados |>
  summarise(
    sem_ideb = sum(is.na(ideb)),
    sem_tdi = sum(is.na(tdi)),
    sem_horas_aula = sum(is.na(hrs_aula)),
    sem_pib_pc = sum(is.na(pib_pc)),
    sem_log_pib = sum(is.na(log_pib))
  )

# Crie a base dados_modelo sem valores ausentes nas variáveis principais:
# ideb, log_pib, tdi e hrs_aula.

dados_modelo <- dados |>
  filter(
    !is.na(ideb),
    !is.na(log_pib),
    !is.na(tdi),
    !is.na(hrs_aula)
  )

# Compare o número de observações antes e depois:

nrow(dados)
nrow(dados_modelo)

# Calcule a correlação entre IDEB e log do PIB:

dados |>
  summarise(
    cor_ideb_pib = cor(ideb, log_pib, use = "complete.obs")
  )

# Comentário:
# A função cor() calcula a correlação entre duas variáveis.

# O argumento use = "complete.obs" indica que o cálculo deve usar
# apenas observações completas, ou seja, linhas sem valores ausentes
# nas variáveis analisadas.

# Se existirem valores NA e esse argumento não for usado,
# o resultado da correlação será NA.

# A correlação varia entre -1 e 1:

# próximo de 1  -> associação positiva forte;
# próximo de -1 -> associação negativa forte;
# próximo de 0  -> pouca associação linear.

# Correlação indica associação entre variáveis,
# mas não significa causalidade.

# Calcule correlações por etapa:

dados |>
  group_by(etapa) |>
  summarise(
    cor_ideb_pib = cor(ideb, log_pib, use = "complete.obs"),
    cor_ideb_tdi = cor(ideb, tdi, use = "complete.obs"),
    .groups = "drop"
  )

# O que uma correlação mede?
# Resposta: mede a direção e a força de uma associação linear entre duas variáveis.

# Correlação indica causalidade?
# Resposta: não. Correlação indica associação, não necessariamente efeito causal.


# ==============================================================================
# 8. VISUALIZAÇÃO COM GGPLOT2
# ===============================================================================

# Gráficos ajudam a entender os dados antes da regressão.


# ------------------------------------------------------------------------------
# Histograma do IDEB
# ------------------------------------------------------------------------------

# Faça um histograma do IDEB:

ggplot(dados) +
  aes(x = ideb) +
  geom_histogram(binwidth = 0.25, color = "white") +
  labs(
    title = "Distribuição do IDEB",
    x = "IDEB",
    y = "Número de observações"
  ) +
  theme_minimal()

# O que o histograma mostra?
# Resposta: mostra como os valores do IDEB estão distribuídos na base.


# ------------------------------------------------------------------------------
# Boxplot do IDEB por etapa
# ------------------------------------------------------------------------------

# Faça um boxplot do IDEB por etapa:

ggplot(dados) +
  aes(x = etapa, y = ideb) +
  geom_boxplot() +
  labs(
    title = "Distribuição do IDEB por etapa",
    x = "Etapa de ensino",
    y = "IDEB"
  ) +
  theme_minimal()

# O que o boxplot permite comparar?
# Resposta: permite comparar a distribuição do IDEB entre etapas, observando
# mediana, dispersão e possíveis valores extremos.


# ------------------------------------------------------------------------------
# Dispersão: log do PIB per capita x IDEB
# ------------------------------------------------------------------------------

# Faça um gráfico de dispersão:
# x = log_pib
# y = ideb

ggplot(dados) +
  aes(x = log_pib, y = ideb) +
  geom_point(alpha = 0.5) +
  labs(
    title = "PIB per capita e IDEB",
    x = "Log do PIB per capita",
    y = "IDEB"
  ) +
  theme_minimal()

# Agora adicione uma reta de regressão:

ggplot(dados) +
  aes(x = log_pib, y = ideb) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Relação entre PIB per capita e IDEB",
    subtitle = "Reta ajustada por regressão linear simples",
    x = "Log do PIB per capita",
    y = "IDEB"
  ) +
  theme_minimal()

# O gráfico indica causalidade?
# Resposta: não. O gráfico mostra associação visual entre as variáveis.


# ==============================================================================
# 9. REGRESSÃO LINEAR SIMPLES
# ===============================================================================

# Modelo geral:
# Y_i = beta0 + beta1 X_i + u_i
# A regressão simples relaciona uma variável dependente Y com uma variável X.


# ------------------------------------------------------------------------------
# Modelo 1: IDEB e PIB per capita
# ------------------------------------------------------------------------------

# Modelo:
# IDEB = beta0 + beta1 log(PIB per capita) + erro

# Estime o modelo:

modelo1 <- lm(
  ideb ~ log_pib,
  data = dados_modelo
)

# Veja os resultados:

summary(modelo1)

# Interprete:
#
# Qual é o sinal do coeficiente de log_pib?
# Resposta: positivo.
#
# Ele é estatisticamente significativo?
# Resposta: sim, se o p-valor for menor que 0,05.
#
# Podemos interpretar como causalidade?
# Resposta: não. A regressão simples mostra associação, não efeito causal.
#
# Interpretação econômica:
# Como log_pib está em log, um aumento de 1% no PIB per capita está associado
# a uma variação aproximada de beta1/100 ponto no IDEB. No resultado da aula,
# isso ficou em torno de 0,004 ponto a mais no IDEB.


# ------------------------------------------------------------------------------
# Modelo 2: IDEB e distorção idade-série
# ------------------------------------------------------------------------------

# Modelo:
# IDEB = beta0 + beta1 TDI + erro

# Estime o modelo:

modelo2 <- lm(
  ideb ~ tdi,
  data = dados_modelo
)

# Veja os resultados:

summary(modelo2)

# Interprete o coeficiente de TDI:
# Resposta:
# O coeficiente mostra a variação média esperada no IDEB associada a um aumento
# de 1 ponto percentual na TDI. Esse resultado é uma associação estatística e
# não deve ser interpretado como causalidade.
#
# Observação:
# Na aula, o coeficiente apareceu positivo e significativo, mas com R² muito
# baixo. Isso indica que o TDI, sozinho, explica muito pouco da variação do IDEB.


# ==============================================================================
# 10. REGRESSÃO MÚLTIPLA
# ===============================================================================

# Na prática, o desempenho educacional não está associado a apenas uma variável.
# Podemos incluir mais variáveis no modelo.

# Modelo:
# IDEB = beta0 + beta1 log_pib + beta2 tdi + beta3 hrs_aula + erro
#
# Não usamos taxa de aprovação porque ela faz parte da construção do IDEB.

# Estime o modelo múltiplo com log_pib, tdi e hrs_aula:

modelo3 <- lm(
  ideb ~ log_pib + tdi + hrs_aula,
  data = dados_modelo
)

# Veja os resultados:

summary(modelo3)

# O que significa interpretação ceteris paribus?
# Resposta:
# Significa interpretar a associação de uma variável com o IDEB mantendo
# constantes as demais variáveis incluídas no modelo.
#
# Observação:
# Nesse modelo, os coeficientes devem ser lidos como associações condicionais.
# Eles ainda não indicam causalidade.


# ==============================================================================
# 11. VARIÁVEIS CATEGÓRICAS
# ===============================================================================

# Como a base tem rede e etapa, podemos incluir essas variáveis no modelo.
# O R cria automaticamente dummies para variáveis de texto ou fator.

# Inclua rede e etapa no modelo:
# ideb ~ log_pib + tdi + hrs_aula + rede + etapa

modelo4 <- lm(
  ideb ~ log_pib + tdi + hrs_aula + rede + etapa,
  data = dados_modelo
)

# Veja os resultados:

summary(modelo4)

# Como o R trata variáveis categóricas?
# Resposta:
# O R transforma automaticamente variáveis categóricas em dummies, omitindo uma
# categoria de referência.

# Qual é a categoria de referência?
# Resposta:
# É a categoria omitida na saída da regressão. A interpretação das demais
# categorias é feita em relação a ela.
#
# Observação:
# No resultado da aula, ao incluir rede e etapa, o R² aumentou. Isso mostra que
# essas características ajudam a explicar parte da variação do IDEB.


# ==============================================================================
# 12. COMPARANDO MODELOS
# ===============================================================================

# Compare os modelos estimados:

summary(modelo1)
summary(modelo2)
summary(modelo3)
summary(modelo4)

# Perguntas e respostas:
#
# O sinal dos coeficientes faz sentido?
# Resposta: deve ser interpretado com base na teoria e no conjunto de controles.
#
# Os coeficientes são estatisticamente significativos?
# Resposta: verificar os p-valores na saída do summary().
#
# O R² aumentou quando adicionamos mais variáveis?
# Resposta: sim, em geral o R² aumenta quando adicionamos variáveis ao modelo.
#
# O que acontece com os coeficientes quando adicionamos controles?
# Resposta: eles podem mudar de tamanho, sinal ou significância, porque passam a
# representar associações condicionais às demais variáveis.
#
# Podemos interpretar os resultados como causais?
# Resposta: não. Esses modelos mostram associações estatísticas. Para falar em
# causalidade, seria necessário discutir estratégia de identificação,
# endogeneidade, variáveis omitidas, seleção etc.


# ==============================================================================
# 13. EXPORTANDO RESULTADOS
# ===============================================================================

# Crie uma pasta resultados caso ela não exista:

if (!dir.exists("resultados")) {
  dir.create("resultados")
}

# Exporte a base final:

write_csv(dados, "resultados/base_final.csv")

# Exporte uma tabela resumida, se quiser:

write_csv(ideb_rede_etapa, "resultados/ideb_medio_rede_etapa.csv")
write_csv(indicadores_rede_etapa, "resultados/indicadores_medios_rede_etapa.csv")


################################################################################
#
# FIM
#
# Nesta aula, passamos por todas as etapas de uma análise aplicada:
#
# dados -> tratamento -> estatísticas -> gráficos -> regressão -> interpretação
#
# Ideia principal:
# R não é apenas uma calculadora. É uma ferramenta para organizar, documentar
# e reproduzir análises empíricas.
#
################################################################################
