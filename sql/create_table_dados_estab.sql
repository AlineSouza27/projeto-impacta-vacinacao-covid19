-- Tabelas analíticas sobre estabelecimentos e estados
-- Base: base_dados_covid19_vacinacao.dados_pct


/********* Tabela 1 - Ranking de estabelecimentos por volume de doses por UF ****************/

CREATE OR REPLACE TABLE base_dados_covid19_vacinacao.dados_estab_ranking_doses AS

SELECT
    uf_vacinacao,
    id_estabelecimento,
    razao_social_estabelecimento,
    COUNT(1)                                                                          AS total_doses,
    SUM(CASE WHEN dose_vacina = '1ª Dose' THEN 1 ELSE 0 END)                         AS total_dose_1,
    SUM(CASE WHEN dose_vacina = '2ª Dose' THEN 1 ELSE 0 END)                         AS total_dose_2,
    ROUND(COUNT(1) / SUM(COUNT(1)) OVER (PARTITION BY uf_vacinacao) * 100, 2)        AS pct_doses_na_uf
FROM base_dados_covid19_vacinacao.dados_pct
GROUP BY uf_vacinacao, id_estabelecimento, razao_social_estabelecimento
ORDER BY uf_vacinacao, total_doses DESC;


/********* Tabela 2 - Taxa de completude vacinal por UF (1ª vs 2ª dose) ****************/

CREATE OR REPLACE TABLE base_dados_covid19_vacinacao.dados_uf_completude_vacinal AS

SELECT
    uf_vacinacao,
    COUNT(1)                                                                          AS total_doses,
    SUM(CASE WHEN dose_vacina = '1ª Dose' THEN 1 ELSE 0 END)                         AS total_dose_1,
    SUM(CASE WHEN dose_vacina = '2ª Dose' THEN 1 ELSE 0 END)                         AS total_dose_2,
    ROUND(
        SAFE_DIVIDE(
            SUM(CASE WHEN dose_vacina = '2ª Dose' THEN 1 ELSE 0 END),
            SUM(CASE WHEN dose_vacina = '1ª Dose' THEN 1 ELSE 0 END)
        ) * 100, 2
    )                                                                                 AS taxa_completude_pct
FROM base_dados_covid19_vacinacao.dados_pct
GROUP BY uf_vacinacao
ORDER BY taxa_completude_pct DESC;


/********* Tabela 3 - Concentração de vacinação por UF (participação dos top 5 estabelecimentos) ****************/

CREATE OR REPLACE TABLE base_dados_covid19_vacinacao.dados_uf_concentracao_vacinal AS

WITH doses_por_estab AS (
    SELECT
        uf_vacinacao,
        id_estabelecimento,
        razao_social_estabelecimento,
        COUNT(1) AS total_doses
    FROM base_dados_covid19_vacinacao.dados_pct
    GROUP BY uf_vacinacao, id_estabelecimento, razao_social_estabelecimento
),
ranking AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY uf_vacinacao ORDER BY total_doses DESC)  AS ranking_uf,
        SUM(total_doses)   OVER (PARTITION BY uf_vacinacao)                      AS total_doses_uf
    FROM doses_por_estab
)
SELECT
    uf_vacinacao,
    MAX(total_doses_uf)                                                               AS total_doses_uf,
    COUNT(DISTINCT id_estabelecimento)                                                AS total_estabelecimentos,
    SUM(CASE WHEN ranking_uf <= 5 THEN total_doses ELSE 0 END)                        AS doses_top5_estab,
    ROUND(
        SUM(CASE WHEN ranking_uf <= 5 THEN total_doses ELSE 0 END)
        / MAX(total_doses_uf) * 100, 2
    )                                                                                 AS pct_doses_top5
FROM ranking
GROUP BY uf_vacinacao
ORDER BY pct_doses_top5 DESC;


/********* Tabela 4 - Diversidade de fabricantes por estabelecimento e UF ****************/

CREATE OR REPLACE TABLE base_dados_covid19_vacinacao.dados_estab_diversidade_fabricante AS

SELECT
    uf_vacinacao,
    id_estabelecimento,
    razao_social_estabelecimento,
    COUNT(DISTINCT nome_fabricante_vacina)                                            AS total_fabricantes,
    COUNT(1)                                                                          AS total_doses,
    STRING_AGG(DISTINCT nome_fabricante_vacina ORDER BY nome_fabricante_vacina)      AS fabricantes_aplicados
FROM base_dados_covid19_vacinacao.dados_pct
GROUP BY uf_vacinacao, id_estabelecimento, razao_social_estabelecimento
ORDER BY uf_vacinacao, total_fabricantes DESC, total_doses DESC;


/********* Tabela 5 - Vacinados por nacionalidade e UF ****************/

CREATE OR REPLACE TABLE base_dados_covid19_vacinacao.dados_uf_nacionalidade AS

SELECT
    uf_vacinacao,
    nacionalidade,
    COUNT(1)                                                                          AS total_vacinados,
    ROUND(COUNT(1) / SUM(COUNT(1)) OVER (PARTITION BY uf_vacinacao) * 100, 2)        AS pct_na_uf
FROM base_dados_covid19_vacinacao.dados_pct
WHERE nacionalidade IS NOT NULL
GROUP BY uf_vacinacao, nacionalidade
ORDER BY uf_vacinacao, total_vacinados DESC;
