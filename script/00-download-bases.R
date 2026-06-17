################################################################################

# DOWNLOAD E PREPARAÇÃO DAS BASES

# Este script mostra como as bases utilizadas na aula foram obtidas
# a partir da Base dos Dados (https://basedosdados.org).

# Não é necessário executar este arquivo para acompanhar a aula prática.
# As bases finais já estão disponíveis na pasta dados/.

################################################################################

# download das bases ------------------------------------------------------

# Para baixar dados da Base dos Dados, é necessário ter um projeto
# no Google Cloud configurado.

# Configure seu projeto Google Cloud:
# basedosdados::set_billing_id("seu_id")

# As consultas abaixo selecionam apenas as variáveis necessárias para a aula.

# Bases utilizadas:

# IDEB municipal: 2023
# Indicadores educacionais municipais: 2023
# PIB municipal: 2022

# IDEB --------------------------------------------------------------------

ideb <- "SELECT ano, sigla_uf, id_municipio, rede, ensino, anos_escolares, ideb
FROM `basedosdados.br_inep_ideb.municipio`
WHERE ano = 2023" |>
  basedosdados::read_sql() |>
  dplyr::mutate_if(bit64::is.integer64, as.integer)


# Indicadores educacionais ------------------------------------------------

indicadores <- "SELECT ano, id_municipio, rede, tdi_ef, tdi_ef_anos_iniciais,
tdi_ef_anos_finais, tdi_em, taxa_aprovacao_ef, taxa_aprovacao_ef_anos_iniciais,
taxa_aprovacao_ef_anos_finais, taxa_aprovacao_em, taxa_reprovacao_ef,
taxa_reprovacao_ef_anos_iniciais, taxa_reprovacao_ef_anos_finais,
taxa_reprovacao_em, taxa_abandono_ef, taxa_abandono_ef_anos_iniciais,
taxa_abandono_ef_anos_finais, taxa_abandono_em, had_ef, had_ef_anos_iniciais,
had_ef_anos_finais, had_em
FROM `basedosdados.br_inep_indicadores_educacionais.municipio`
WHERE ano = 2023" |>
  basedosdados::read_sql() |>
  dplyr::mutate_if(bit64::is.integer64, as.integer)


# PIB e população municipal -----------------------------------------------

pib <- "SELECT
    pib.id_municipio,
    pib.ano,
    pib.pib,
    pop.populacao
FROM `basedosdados.br_ibge_pib.municipio` AS pib
LEFT JOIN `basedosdados.br_ibge_populacao.municipio` AS pop
    ON pib.id_municipio = pop.id_municipio
    AND pib.ano = pop.ano
WHERE pib.ano = 2022" |>
  basedosdados::read_sql() |>
  dplyr::mutate(
    ano = as.integer(ano),
    pib = as.numeric(pib),
    populacao = as.numeric(populacao)
  )


# padronização das bases --------------------------------------------------

# Nesta etapa, as bases são organizadas para ficarem compatíveis
# com os scripts da aula prática.

# Unidade de observação das bases educacionais:

# ano + município + rede + etapa de ensino

# A base do PIB está no nível do município.


# Indicadores educacionais ------------------------------------------------

# A base original de indicadores possui variáveis separadas por etapa.
# Aqui, organizamos essas variáveis para criar uma base com:

# ano
# id_municipio
# rede
# etapa
# tdi
# taxa_aprovacao
# taxa_reprovacao
# taxa_abandono
# hrs_aula

indicadores <- indicadores |>
  dplyr::mutate(
    id_municipio = as.character(id_municipio),
    rede = stringr::str_to_lower(rede),
    rede = stringi::stri_trans_general(rede, "Latin-ASCII")
  ) |>
  dplyr::group_by(ano, id_municipio, rede) |>
  dplyr::summarise(
    dplyr::across(
      where(is.numeric),
      ~ ifelse(all(is.na(.x)), NA_real_, mean(.x, na.rm = TRUE))
    ),
    .groups = "drop"
  ) |>
  dplyr::select(
    ano, id_municipio, rede,
    tdi_ef_anos_iniciais,
    tdi_ef_anos_finais,
    tdi_em,
    taxa_aprovacao_ef_anos_iniciais,
    taxa_aprovacao_ef_anos_finais,
    taxa_aprovacao_em,
    taxa_reprovacao_ef_anos_iniciais,
    taxa_reprovacao_ef_anos_finais,
    taxa_reprovacao_em,
    taxa_abandono_ef_anos_iniciais,
    taxa_abandono_ef_anos_finais,
    taxa_abandono_em,
    had_ef_anos_iniciais,
    had_ef_anos_finais,
    had_em
  ) |>
  tidyr::pivot_longer(
    cols = -c(ano, id_municipio, rede),
    names_to = c("variavel", "etapa"),
    names_pattern = "(tdi|taxa_aprovacao|taxa_reprovacao|taxa_abandono|had)_(.*)",
    values_to = "valor"
  ) |>
  dplyr::mutate(
    variavel = dplyr::case_when(
      variavel == "had" ~ "hrs_aula",
      TRUE ~ variavel
    ),
    etapa = dplyr::case_when(
      etapa == "ef_anos_iniciais" ~ "EF anos iniciais",
      etapa == "ef_anos_finais" ~ "EF anos finais",
      etapa == "em" ~ "EM"
    )
  ) |>
  dplyr::filter(
    rede %in% c("estadual", "municipal", "federal")
  ) |>
  tidyr::pivot_wider(
    names_from = variavel,
    values_from = valor
  )


# IDEB --------------------------------------------------------------------

# A base do IDEB também é padronizada para manter a mesma estrutura:

# ano
# id_municipio
# rede
# etapa
# ideb

ideb <- ideb |>
  dplyr::mutate(
    id_municipio = as.character(id_municipio),
    rede = stringr::str_to_lower(rede),
    rede = stringi::stri_trans_general(rede, "Latin-ASCII"),
    etapa = dplyr::case_when(
      ensino == "fundamental" & anos_escolares == "iniciais (1-5)" ~ "EF anos iniciais",
      ensino == "fundamental" & anos_escolares == "finais (6-9)" ~ "EF anos finais",
      ensino == "medio" ~ "EM",
      TRUE ~ NA_character_
    )
  ) |>
  dplyr::filter(
    rede %in% c("estadual", "municipal", "federal")
  ) |>
  dplyr::select(
    ano,
    id_municipio,
    rede,
    etapa,
    ideb
  )


# PIB ---------------------------------------------------------------------

# A base do PIB é mantida no nível municipal.

# As variáveis pib_pc, pib_pc_mil e log_pib serão criadas depois,
# no script da aula prática, para fins didáticos.

pib <- pib |>
  dplyr::mutate(
    id_municipio = as.character(id_municipio),
    ano = as.integer(ano),
    pib = as.numeric(pib),
    populacao = as.numeric(populacao),
    # pib_pc = pib / populacao,
    # pib_pc_mil = pib_pc / 1000,
    # log_pib = log(pib_pc),
    ano_pib = ano
  ) |>
  dplyr::select(
    id_municipio,
    ano_pib,
    pib,
    populacao,
    # pib_pc,
    # pib_pc_mil,
    # log_pib
  )


# salvando as bases -------------------------------------------------------

# As bases finais são salvas em formato .csv na pasta dados/.

# Esses são os arquivos utilizados nos scripts da aula prática.

readr::write_csv(ideb, "dados/ideb.csv")
readr::write_csv(indicadores, "dados/indicadores.csv")
readr::write_csv(pib, "dados/pib.csv")

