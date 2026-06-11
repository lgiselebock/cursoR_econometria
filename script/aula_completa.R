################################################################################
#
# INTRODUÇÃO AO R APLICADO À ECONOMETRIA I
#
# ROTEIRO DO PROFESSOR - CÓDIGO COMPLETO
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

library(tidyverse)

# Comentário:
# O pacote tidyverse reúne várias funções úteis para importar, organizar,
# transformar e visualizar dados.
# As mensagens indicam quais pacotes foram carregados.
# Os conflitos com filter() e lag() são normais e não representam erro.


# ==============================================================================
# 1. PRIMEIROS PASSOS COM O R
# ==============================================================================

# Faça algumas operações matemáticas:

2 + 2
10 - 5
5 * 3
10 / 2

# Comentário:
# O R pode ser usado como uma calculadora.
# Cada operação retorna diretamente o resultado no console.

# Crie um objeto x recebendo o valor 10:

x <- 10

# Veja o objeto x:

x

# Use o objeto x em algumas operações:

x + 5
x * 2

# Comentário:
# O objeto x recebeu o valor 10.
# Depois, usamos esse objeto em novas operações.
# Isso mostra que objetos armazenam informações que podem ser reutilizadas.

# Crie um objeto chamado media_turma:

media_turma <- 8.5
media_turma

# Comentário:
# Criamos um objeto chamado media_turma.
# O nome do objeto ajuda a entender o que aquele valor representa.

# ==============================================================================
# 2. CLASSES DE OBJETOS
# ==============================================================================

# Crie um número e veja sua classe:

idade <- 25
class(idade)

# Comentário:
# A variável idade é numérica.
# Objetos numéricos permitem operações matemáticas.

# Crie um texto e veja sua classe:

curso <- "Economia"
class(curso)

# Comentário:
# A variável curso é do tipo character, ou seja, texto.
# Valores de texto devem ficar entre aspas.

# Crie um valor lógico e veja sua classe:

aprovado <- TRUE
class(aprovado)

# Comentário:
# A variável aprovado é lógica.
# Objetos lógicos assumem valores TRUE ou FALSE.

# ==============================================================================
# 3. IMPORTANDO BASES DE DADOS
# ==============================================================================

# Bases utilizadas:
#
# ideb.csv
# indicadores.csv
# pib.csv

# Importe a base do IDEB:

ideb <- read_csv("dados/ideb.csv")

# Importe a base de indicadores:

indicadores <- read_csv("dados/indicadores.csv")

# Importe a base do PIB:

pib <- read_csv("dados/pib.csv")

# Comentário:
# Foram importadas três bases:
# ideb: contém informações do IDEB por município, rede e etapa.
# indicadores: contém indicadores educacionais, como TDI, aprovação,
# reprovação, abandono e horas-aula.
# pib: contém PIB e população dos municípios.
# As mensagens do read_csv mostram o número de linhas, colunas e tipos das variáveis.

# ==============================================================================
# 4. CONHECENDO AS BASES
# ==============================================================================

# Antes de qualquer análise, precisamos olhar os dados.
# Nunca comece uma regressão sem antes entender a base.

# Veja as primeiras linhas:

head(ideb)
head(indicadores)
head(pib)

# Comentário:
# A função head() mostra as primeiras linhas de cada base.
# Isso ajuda a conferir se os dados foram importados corretamente.

# Abra as bases:

View(ideb)
View(indicadores)
View(pib)

# Veja a estrutura:

glimpse(ideb)
glimpse(indicadores)
glimpse(pib)

# Comentário:
# A função glimpse() mostra a estrutura da base.
# Podemos ver o número de linhas, colunas, nomes das variáveis e seus tipos.
# As três bases foram importadas corretamente.

# Veja estatísticas básicas:

summary(ideb)
summary(indicadores)
summary(pib)

# Comentário:
# A função summary() apresenta estatísticas descritivas.
# No caso do IDEB, a média é aproximadamente 4,97, mas há valores ausentes.
# Na base de indicadores, também há muitos valores ausentes em algumas variáveis.
# Na base do PIB, observamos grande diferença entre municípios,
# o que é esperado porque há municípios pequenos e grandes capitais.

# Veja dimensões, número de linhas e colunas:

dim(ideb)
dim(indicadores)
dim(pib)

# Comentário:
# A base do IDEB tem 23.926 linhas e 5 colunas.
# A base de indicadores tem 35.127 linhas e 9 colunas.
# A base de PIB tem 5.570 linhas e 4 colunas.

nrow(ideb)
nrow(indicadores)
nrow(pib)

ncol(ideb)
ncol(indicadores)
ncol(pib)

# Comentário:
# nrow() mostra o número de linhas.
# ncol() mostra o número de colunas.
# Essas funções ajudam a verificar o tamanho das bases.

# Veja os nomes das variáveis:

names(ideb)
names(indicadores)
names(pib)

# Comentário:
# A função names() mostra os nomes das variáveis.
# Isso é importante para saber quais variáveis podem ser usadas nos próximos comandos.

# Perguntas:
#
# O que representa uma linha da base do IDEB?
# O que representa uma linha da base de indicadores?
# O que representa uma linha da base do PIB?
# As três bases possuem a mesma unidade de observação?
# Qual é a chave para juntar as bases educacionais?
# Qual é a chave para juntar a base do PIB?
#
# Resposta esperada:
# - IDEB: uma combinação de ano, município, rede e etapa.
# - Indicadores: uma combinação de ano, município, rede e etapa.
# - PIB: uma observação por município.
# - As bases educacionais têm a mesma unidade; a base do PIB está em outro nível.
# - IDEB + indicadores: ano, id_municipio, rede e etapa.
# - PIB: id_municipio.


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
# ano, id_municipio, rede, etapa e ideb.

ideb2 <- ideb |>
  select(
    ano,
    id_municipio,
    rede,
    etapa,
    ideb
  )

# Veja as primeiras linhas de ideb2:

head(ideb2)

# Comentário:
# O select() foi usado para escolher apenas algumas colunas.
# Nesse caso, a base ideb2 ficou igual à base original,
# pois essas já eram as principais variáveis disponíveis.

# ------------------------------------------------------------------------------
# FILTER()
# ------------------------------------------------------------------------------

# Filtre observações com IDEB maior que 7:

ideb |>
  filter(ideb > 7)

# Comentário:
# Esse filtro seleciona apenas observações com IDEB maior que 7.
# Foram encontradas 544 observações.
# Esses são casos com desempenho educacional elevado.

# Filtre apenas EF anos iniciais:

ideb |>
  filter(etapa == "EF anos iniciais")

# Comentário:
# Esse filtro seleciona apenas os anos iniciais do ensino fundamental.
# A base resultante possui 8.931 observações.

# Filtre apenas rede municipal:

ideb |>
  filter(rede == "municipal")

# Comentário:
# Esse filtro seleciona apenas a rede municipal.
# A base resultante possui 9.442 observações.

# Combine filtros:
# rede municipal + EF anos iniciais

ideb |>
  filter(
    rede == "municipal",
    etapa == "EF anos iniciais"
  )

# Comentário:
# Aqui combinamos dois critérios:
# rede municipal e anos iniciais do ensino fundamental.
# A base resultante possui 5.433 observações.
# Isso mostra como podemos restringir a análise a um grupo específico.


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

# Resposta esperada:
# O R retorna erro porque pib_pc ainda não existe na base.
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

# Comentário:
# Criamos o PIB per capita dividindo o PIB pela população.
# Também criamos o PIB per capita em mil reais, para facilitar a leitura.
# O erro anterior ocorreu porque tentamos criar pib_pc_mil antes de criar pib_pc.

# Crie o log do PIB per capita:

pib <- pib |>
  mutate(
    log_pib = log(pib_pc)
  )

# Comentário:
# Criamos o logaritmo do PIB per capita.
# O log é muito usado em econometria porque ajuda a reduzir assimetrias
# e facilita a interpretação de relações proporcionais.

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

# Comentário:
# Criamos uma variável que classifica os municípios em dois grupos:
# acima ou abaixo da mediana do PIB per capita.
# Como usamos a mediana, a base ficou dividida igualmente:
# 2.785 municípios abaixo da mediana e 2.785 acima da mediana.


# ------------------------------------------------------------------------------
# ARRANGE()
# ------------------------------------------------------------------------------

# arrange() ordena a base.

# Ordene os maiores valores de IDEB:

ideb |>
  arrange(desc(ideb))

# Comentário:
# O arrange(desc()) ordena a base do maior para o menor IDEB.
# Os maiores valores aparecem principalmente nos anos iniciais do ensino fundamental.

# Ordene os menores valores de IDEB:

ideb |>
  arrange(ideb)

# Comentário:
# Aqui a base foi ordenada do menor para o maior IDEB.
# Os menores valores aparecem principalmente nos anos finais e no ensino médio.

# ------------------------------------------------------------------------------
# COUNT()
# ------------------------------------------------------------------------------

# count() conta observações por grupo.

# Conte observações por rede:

ideb |>
  count(rede) #|>
  # arrange(n)
  # arrange(desc(n))

# Comentário:
# A base possui observações das redes estadual, federal e municipal.
# A rede estadual tem o maior número de observações,
# seguida pela municipal e pela federal.

# Conte observações por rede e etapa:

ideb |>
  count(rede, etapa)

# Comentário:
# Esse comando conta as observações por rede e etapa.
# Ele mostra que a distribuição das observações não é igual entre os grupos.
# A rede federal, por exemplo, tem poucas observações no ensino fundamental.

# Conte observações com IDEB não ausente por rede e etapa:

ideb |>
  filter(!is.na(ideb)) |>
  count(rede, etapa)

# Comentário:
# Aqui contamos apenas as observações com IDEB disponível.
# Isso é importante porque nem todas as linhas possuem valor de IDEB.
# A ausência de dados deve ser considerada antes das análises.


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
#
# Resposta esperada:
# O resultado aparece como NA porque existem valores ausentes na variável ideb.
# Por padrão, mean(), sd(), min() e max() não ignoram valores ausentes.
# Quando há NA, precisamos usar na.rm = TRUE para ignorar esses valores.

# Agora repita usando na.rm = TRUE:

ideb |>
  summarise(
    media_ideb = mean(ideb, na.rm = TRUE),
    desvio_ideb = sd(ideb, na.rm = TRUE),
    minimo_ideb = min(ideb, na.rm = TRUE),
    maximo_ideb = max(ideb, na.rm = TRUE)
  )

# Comentário:
# A média do IDEB é 4,97.
# O menor valor observado é 2,1 e o maior é 10.
# O desvio-padrão é aproximadamente 1,03,
# indicando variação relevante entre as observações.


# O que significa na.rm = TRUE?

# Resposta esperada:
# Significa remover os valores NA antes de calcular a estatística.


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
  ) #|>
  # ungroup()

ideb_rede

# Comentário:
# A rede federal apresenta a maior média de IDEB.
# A rede municipal aparece em seguida.
# A rede estadual apresenta a menor média.
# Porém, a rede federal tem muito menos observações, então a comparação exige cautela.

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
# Os anos iniciais do ensino fundamental apresentam a maior média de IDEB.
# O ensino médio apresenta a menor média.
# Isso mostra que os resultados educacionais variam bastante conforme a etapa.

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

# Comentário:
# Separando por rede e etapa, as diferenças ficam mais claras.
# A rede federal tem médias maiores em todas as etapas,
# mas com número reduzido de observações.
# Os anos iniciais têm IDEB médio maior do que os anos finais e o ensino médio.

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

# Comentário:
# Essa tabela compara os indicadores educacionais por rede e etapa.
# Observamos diferenças importantes entre grupos.
# Algumas médias parecem pouco intuitivas, especialmente em aprovação,
# abandono e horas-aula, o que pode estar relacionado à forma como os dados
# foram agregados ou à presença de muitos valores ausentes.
# Por isso, esses resultados devem ser interpretados com cuidado.


# Perguntas:

# O IDEB médio parece diferente entre redes?
# Qual etapa apresenta maior taxa de abandono?
# Essas diferenças significam causalidade?

# Resposta esperada:
# As médias mostram diferenças descritivas entre grupos, mas não indicam causalidade.


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

# Comentário:
# Não foram encontradas duplicidades nas chaves usadas.
# Isso é importante porque evita que o cruzamento das bases multiplique linhas
# indevidamente.



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

# Comentário:
# A base final reúne informações de IDEB, indicadores educacionais e PIB.
# O left_join mantém todas as observações da base de IDEB.
# A base final tem 23.926 observações e 17 variáveis.
# O PIB é de 2022, enquanto o IDEB e os indicadores educacionais são de 2023.
# Portanto, o PIB é usado como uma aproximação das condições econômicas municipais.

# ==============================================================================
# 7. ANÁLISE EXPLORATÓRIA
# ==============================================================================

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

# Comentário:
# Na base final, o IDEB médio é aproximadamente 4,97.
# O TDI médio é cerca de 19,6 %.
# Em média, aproximadamente 19,6% dos alunos estão em situação
# de distorção idade-série nas observações da base.
# A média do PIB per capita é aproximadamente R$ 37,2 mil.
# Essas médias resumem a base como um todo,
# mas ainda misturam redes e etapas diferentes.

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

# Comentário:
# Ao separar por rede e etapa, vemos que o IDEB médio varia bastante.
# Os anos iniciais apresentam IDEB mais alto.
# O ensino médio apresenta IDEB mais baixo.
# A rede federal tem médias maiores, mas poucas observações,
# especialmente no ensino fundamental.


# Verifique valores ausentes por variável:

colSums(is.na(dados))

# Comentário:
# Antes de estimar modelos, é importante verificar se existem dados faltantes.
# O comando abaixo conta quantos valores NA existem em cada variável.
# Variáveis com muitos valores ausentes podem reduzir o número de observações
# disponíveis para a análise.

# Comentário:
# A função is.na() verifica se existem valores ausentes (NA) na base.
# A função colSums() soma esses valores para cada coluna.
# O resultado mostra quantas observações estão sem informação em cada variável.

# Resultado:
# Algumas variáveis possuem valores ausentes.
# Por exemplo, existem observações sem informação de IDEB, TDI e horas-aula.
# Isso é comum em bases reais e precisa ser analisado antes das próximas etapas.

# Verifique valores ausentes nas principais variáveis da análise:

dados |>
  summarise(
    sem_ideb = sum(is.na(ideb)),
    sem_tdi = sum(is.na(tdi)),
    sem_horas_aula = sum(is.na(hrs_aula)),
    sem_pib_pc = sum(is.na(pib_pc)),
    sem_log_pib = sum(is.na(log_pib))
  )

# Comentário:
# Há muitos valores ausentes em algumas variáveis.
# Existem 5.464 observações sem IDEB,
# 11.296 sem TDI e 14.043 sem horas-aula.
# Não há valores ausentes em PIB per capita ou log do PIB.
# Isso afeta diretamente o número de observações usadas nas regressões.


# Crie a base dados_modelo sem valores ausentes nas variáveis principais:
# ideb, log_pib, tdi e hrs_aula

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

# Comentário:
# A base completa tem 23.926 observações.
# A base usada nos modelos tem 7.096 observações.
# Isso ocorre porque o modelo só usa linhas completas nas variáveis selecionadas.
# Portanto, os resultados das regressões se referem a essa subamostra.


# Calcule a correlação entre IDEB e log do PIB:

dados |>
  summarise(
    cor_ideb_pib = cor(ideb, log_pib, use = "complete.obs")
  )

# Comentário:
# A correlação entre IDEB e log do PIB per capita é positiva,
# aproximadamente 0,23.
# Isso indica uma associação positiva, mas não muito forte.
# Municípios com maior PIB per capita tendem a ter IDEB maior,
# mas essa relação não é determinística.


# Calcule correlações por etapa:

dados |>
  group_by(etapa) |>
  summarise(
    cor_ideb_pib = cor(ideb, log_pib, use = "complete.obs"),
    cor_ideb_tdi = cor(ideb, tdi, use = "complete.obs"),
    .groups = "drop"
  )

# Comentário:
# A correlação entre IDEB e PIB per capita é positiva nas três etapas.
# Ela é maior nos anos iniciais e finais do ensino fundamental.
# A correlação entre IDEB e TDI é muito próxima de zero.
# Isso sugere pouca associação linear simples entre IDEB e TDI nesta base.


# O que uma correlação mede?

# Resposta esperada:
# Mede a direção e a força de uma associação linear entre duas variáveis.

# Correlação indica causalidade?

# Resposta esperada:
# Não. Correlação indica associação, não necessariamente efeito causal.


# ==============================================================================
# 8. VISUALIZAÇÃO COM GGPLOT2
# ==============================================================================

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

# Comentário:
# O histograma mostra a distribuição dos valores do IDEB.
# O aviso informa que observações sem IDEB foram removidas do gráfico.
# Isso é esperado e não representa erro.


# O que o histograma mostra?

# Resposta esperada:
# Mostra como os valores do IDEB estão distribuídos na base.


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

# Comentário:
# O boxplot compara o IDEB entre etapas.
# Os anos iniciais tendem a apresentar valores mais elevados.
# O ensino médio apresenta valores menores.


# O que o boxplot permite comparar?

# Resposta esperada:
# Permite comparar a distribuição do IDEB entre etapas, incluindo mediana,
# dispersão e possíveis valores extremos.

# Comentário:
# O boxplot mostra a distribuição de uma variável.
# Ele permite comparar grupos e identificar diferenças na mediana,
# na dispersão dos dados e possíveis valores extremos (outliers).
#
# Como interpretar:
#
# - A linha no meio da caixa representa a mediana:
#   metade das observações está acima desse valor e metade abaixo.
#
# - A caixa representa onde estão concentrados 50% dos dados:
#   quanto maior a caixa, maior a variação dos valores.
#
# - As linhas que saem da caixa ("bigodes") mostram a dispersão dos dados.
#
# - Os pontos fora dos bigodes representam possíveis valores extremos
#   (outliers).

# Comentário:
# O gráfico compara a distribuição do IDEB entre as etapas de ensino.
#
# Observamos que os anos iniciais do ensino fundamental possuem
# uma mediana de IDEB mais elevada.
#
# O ensino médio apresenta valores menores de IDEB.
#
# A altura das caixas mostra que existe variação no desempenho
# mesmo dentro da mesma etapa.
#
# Os pontos fora dos limites indicam municípios/redes com resultados
# muito diferentes do padrão observado.

# "O boxplot resume uma distribuição. A linha dentro da caixa mostra o valor
# central, a mediana. A caixa mostra onde está a maior parte das observações.
# Então, quando comparo as caixas dos anos iniciais, anos finais e ensino médio,
# consigo ver rapidamente qual etapa apresenta IDEB mais alto e onde existe
# maior variação entre os municípios."

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

# Comentário:
# O gráfico de dispersão mostra a relação entre PIB per capita e IDEB.
# Há uma tendência positiva, mas os pontos estão bastante espalhados.
# Isso indica que o PIB per capita não explica sozinho o desempenho educacional.

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

# Comentário:
# A reta de regressão tem inclinação positiva.
# Isso reforça a existência de uma associação positiva entre PIB per capita e IDEB.
# Porém, como há grande dispersão dos pontos, a relação não é perfeita.


# O gráfico indica causalidade?

# Resposta esperada:
# Não. O gráfico mostra associação visual entre as variáveis.


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

modelo1 <- lm(
  ideb ~ log_pib,
  data = dados_modelo
)

# Veja os resultados:

summary(modelo1)

# Comentário:
# O coeficiente de log_pib é positivo e estatisticamente significativo.
# Isso indica que municípios com maior PIB per capita tendem a apresentar IDEB maior.
# O R² é aproximadamente 0,077.
# Portanto, o PIB per capita sozinho explica cerca de 7,7% da variação do IDEB.

# Apesar da relação positiva entre PIB per capita e IDEB,
# o R² mostra que essa variável sozinha explica apenas uma pequena parte
# das diferenças de desempenho educacional.
#
# Outros fatores também são importantes para explicar o IDEB.

# Interprete:

# Qual é o sinal do coeficiente de log_pib?
# Ele é estatisticamente significativo?
# Podemos interpretar como causalidade?

# Resposta esperada:
# Depende do resultado estimado. A interpretação deve considerar sinal,
# p-valor e que a regressão simples mostra associação, não causalidade.

# Comentário:
# O coeficiente do log do PIB per capita é positivo (0,385).
# Como o PIB está em logaritmo, interpretamos aproximadamente que
# um aumento de 1% no PIB per capita está associado a um aumento
# de 0,004 ponto no IDEB.

# Como o PIB está em logaritmo, interpretamos aproximadamente que
# um aumento de 1% no PIB per capita está associado a um aumento
# de 0,004 ponto no IDEB.
#
# Portanto, municípios com maior PIB per capita tendem a apresentar
# IDEB mais elevado.
#
# Essa relação é estatisticamente significativa (p-valor < 0,05),
# mas representa apenas uma associação, não uma relação causal.


# ------------------------------------------------------------------------------
# Modelo 2: IDEB e distorção idade-série
# ------------------------------------------------------------------------------

# Modelo:
#
# IDEB = beta0 + beta1 TDI + erro

# Estime o modelo:

modelo2 <- lm(
  ideb ~ tdi,
  data = dados_modelo
)

# Veja os resultados:

summary(modelo2)

# Comentário:
# O coeficiente do TDI é positivo e estatisticamente significativo.
# Porém, o R² é muito baixo, cerca de 0,002.
# Isso significa que o TDI, sozinho, quase não explica a variação do IDEB.
# Esse exemplo mostra que significância estatística não significa grande poder explicativo.

# Interprete o coeficiente de TDI:

# Resposta esperada:
# Se o coeficiente for negativo, observações com maior distorção idade-série
# tendem a apresentar, em média, menor IDEB.

# Comentário:
# O intercepto indica o valor esperado do IDEB quando o TDI é igual a zero.
# Neste modelo, escolas/redes com TDI igual a zero teriam,
# em média, IDEB previsto de aproximadamente 4,90.

# Comentário:
# O coeficiente do TDI é 0,011.
# Isso significa que um aumento de 1 ponto percentual na taxa de
# distorção idade-série está associado a um IDEB aproximadamente
# 0,011 ponto maior, em média.

# O coeficiente é estatisticamente significativo (p-valor < 0,05),
# indicando associação entre TDI e IDEB.
#
# Porém, o R² é aproximadamente 0,002.
# Isso significa que o TDI sozinho explica apenas cerca de 0,2%
# da variação observada no IDEB.
#
# Além disso, o sinal positivo deve ser interpretado com cuidado,
# pois a regressão simples não controla diferenças entre redes,
# etapas de ensino e outras características.
#
# O resultado representa apenas uma associação, não uma relação causal.

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
# log_pib, tdi e hrs_aula

modelo3 <- lm(
  ideb ~ log_pib + tdi + hrs_aula,
  data = dados_modelo
)

# Veja os resultados:

summary(modelo3)

# Comentário:
# Nesse modelo, incluímos PIB per capita, TDI e horas-aula.
# O R² aumenta para aproximadamente 0,226.
# Isso indica que o conjunto de variáveis explica cerca de 22,6% da variação do IDEB.
# O log do PIB continua positivo e significativo.
# O coeficiente de horas-aula aparece negativo.
# Esse resultado deve ser interpretado com cuidado:
# trata-se de associação estatística, não de efeito causal.

# O intercepto representa o IDEB esperado quando todas as variáveis
# explicativas são iguais a zero.
# Neste caso, ele não possui interpretação prática relevante,
# pois essa situação não ocorre nos dados analisados.

# O coeficiente do log do PIB per capita é positivo.
# Mantendo constantes TDI e horas-aula, um aumento de 1%
# no PIB per capita está associado a um aumento médio
# de aproximadamente 0,0035 ponto no IDEB.

# O coeficiente do TDI indica que um aumento de 1 ponto percentual
# na taxa de distorção idade-série está associado a um aumento
# médio de aproximadamente 0,007 ponto no IDEB,
# mantendo as demais variáveis constantes.
# Esse resultado deve ser interpretado com cuidado,
# pois o sinal positivo não significa que aumentar a distorção
# idade-série melhora o IDEB.
# A regressão mostra apenas associação entre as variáveis.

# O coeficiente de horas-aula é negativo.
# Mantendo constantes PIB per capita e TDI,
# uma unidade adicional em horas-aula está associada
# a um IDEB aproximadamente 0,014 ponto menor.
#
# Esse resultado não deve ser interpretado como causal:
# escolas com mais horas-aula podem possuir outras características
# que não estão sendo controladas pelo modelo.

# O que significa interpretação ceteris paribus?
#
# Resposta esperada:
# Significa interpretar a associação de uma variável explicativa com o IDEB
# mantendo constantes as demais variáveis incluídas no modelo.


# ==============================================================================
# 11. VARIÁVEIS CATEGÓRICAS
# ==============================================================================

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

# Comentário:
# O modelo 4 adiciona controles para rede de ensino e etapa.
# O R² aumenta para aproximadamente 0,353,
# indicando que o modelo passa a explicar cerca de 35,3% da variação do IDEB.
# O log do PIB per capita continua positivo e significativo.
# O TDI deixa de ser estatisticamente significativo.
# Isso sugere que parte da associação entre TDI e IDEB estava relacionada
# às diferenças entre redes e etapas.
# A variável de anos iniciais tem coeficiente positivo,
# indicando IDEB maior em relação à categoria de referência.
# O ensino médio tem coeficiente negativo,
# indicando IDEB menor em relação à categoria de referência.
# A rede federal apresenta coeficiente positivo,
# mas tem poucas observações; por isso, a interpretação deve ser cautelosa.

# Como o R trata variáveis categóricas?

# Resposta esperada:
# O R transforma automaticamente variáveis categóricas em dummies,
# usando uma das categorias como referência.

# O intercepto representa o IDEB esperado para a categoria de referência
# (rede estadual e EF anos finais), quando as demais variáveis são iguais a zero.
# Neste caso, ele serve principalmente para ajustar o modelo.

# O coeficiente do log do PIB continua positivo.
# Controlando por características educacionais, rede e etapa,
# municípios com maior PIB per capita tendem a apresentar IDEB maior.
#
# Um aumento de 1% no PIB per capita está associado
# a aproximadamente 0,003 ponto a mais no IDEB.

# O coeficiente do TDI deixa de ser estatisticamente significativo.
# Isso indica que, depois de controlar pelas demais características,
# não encontramos evidência de associação entre TDI e IDEB neste modelo.

# Diferentemente do modelo anterior, o coeficiente de horas-aula passa
# a ser positivo após controlar por rede e etapa.
#
# Isso mostra que a relação entre duas variáveis pode mudar quando
# incluímos novos controles no modelo.

# A rede federal apresenta IDEB médio maior em relação à rede estadual,
# mantendo constantes as demais características.
#
# Essa comparação deve ser feita com cuidado,
# pois há menos observações da rede federal na base.

# O coeficiente da rede municipal indica diferença média em relação
# à rede estadual (categoria de referência).
#
# Neste modelo, a rede municipal apresenta IDEB cerca de 0,19 ponto menor.

# Os anos iniciais apresentam IDEB médio superior aos anos finais,
# mesmo após controlar pelas demais variáveis.

# O ensino médio apresenta IDEB médio inferior aos anos finais
# do ensino fundamental.

# Conclusão:
# Ao adicionar controles, a interpretação dos coeficientes muda.
#
# O PIB per capita continua positivamente associado ao IDEB.
# O efeito do TDI deixa de ser estatisticamente significativo.
# A relação das horas-aula muda de negativa para positiva.
#
# Isso mostra a importância de considerar outras características
# antes de interpretar relações entre variáveis.
#
# Esses resultados indicam associações, não relações causais.

# Qual é a categoria de referência?

# Resposta esperada:
# É a categoria omitida na saída da regressão. Ela aparece no intercepto.

# ==============================================================================
# 12. COMPARANDO MODELOS
# ==============================================================================

# Compare os modelos estimados:

summary(modelo1)
summary(modelo2)
summary(modelo3)
summary(modelo4)

# Perguntas:

# O sinal dos coeficientes faz sentido?
# Os coeficientes são estatisticamente significativos?
# O R² aumentou quando adicionamos mais variáveis?
# O que acontece com os coeficientes quando adicionamos controles?
# Podemos interpretar os resultados como causais?

# Resposta esperada:
# A regressão mostra associações estatísticas condicionais.
# Para falar em causalidade, precisaríamos discutir identificação, hipóteses,
# possível endogeneidade, variáveis omitidas, seleção etc.


# Observação geral:
# As regressões estimam associações entre variáveis.
# Não podemos afirmar causalidade apenas com esses modelos.
# Portanto, não devemos dizer que maior PIB per capita causa maior IDEB,
# apenas que há uma associação positiva entre essas variáveis na amostra.

# ==============================================================================
# 13. EXPORTANDO RESULTADOS
# ==============================================================================

# Crie uma pasta resultados caso ela não exista:

if (!dir.exists("resultados")) {
  dir.create("resultados")
}

# Exporte a base final:

write_csv(dados, "resultados/base_final.csv")

# Exporte uma tabela resumida, se quiser:

write_csv(ideb_rede_etapa, "resultados/ideb_medio_rede_etapa.csv")
write_csv(indicadores_rede_etapa, "resultados/indicadores_medios_rede_etapa.csv")

# Comentário:
# Criamos uma pasta chamada resultados, caso ela ainda não exista.
# Depois, exportamos a base final e algumas tabelas resumidas em formato CSV.
# Esses arquivos podem ser abertos depois no Excel, LibreOffice ou no próprio R.


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
