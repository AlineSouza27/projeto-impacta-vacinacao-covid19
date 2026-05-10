-- Tabelas analíticas sobre lotes das vacinas aplicadas
-- Base: basedosdados.br_ms_vacinacao_covid19


/********* Tabela 1 - Total de doses aplicadas por lote ****************/

CREATE OR REPLACE TABLE base_dados_covid19_vacinacao.dados_lote_total_doses AS

SELECT
    lote_vacina,
    nome_fabricante_vacina,
    COUNT(1) AS total_doses_aplicadas
FROM basedosdados.br_ms_vacinacao_covid19.microdados
GROUP BY lote_vacina, nome_fabricante_vacina
ORDER BY total_doses_aplicadas DESC;


/********* Tabela 2 - Distribuição de lotes por fabricante ****************/

CREATE OR REPLACE TABLE base_dados_covid19_vacinacao.dados_lote_por_fabricante AS

SELECT
    nome_fabricante_vacina,
    COUNT(DISTINCT lote_vacina) AS total_lotes,
    COUNT(1)                    AS total_doses
FROM basedosdados.br_ms_vacinacao_covid19.microdados
GROUP BY nome_fabricante_vacina
ORDER BY total_lotes DESC;


/********* Tabela 3 - Período de utilização por lote ****************/

CREATE OR REPLACE TABLE base_dados_covid19_vacinacao.dados_lote_periodo_utilizacao AS

SELECT
    lote_vacina,
    nome_fabricante_vacina,
    MIN(data_aplicacao_vacina)                                                 AS primeira_aplicacao,
    MAX(data_aplicacao_vacina)                                                 AS ultima_aplicacao,
    DATE_DIFF(MAX(data_aplicacao_vacina), MIN(data_aplicacao_vacina), DAY)     AS dias_em_uso
FROM basedosdados.br_ms_vacinacao_covid19.microdados
GROUP BY lote_vacina, nome_fabricante_vacina
ORDER BY dias_em_uso DESC;


/********* Tabela 4 - Lotes aplicados por UF ****************/

CREATE OR REPLACE TABLE base_dados_covid19_vacinacao.dados_lote_por_uf AS

SELECT
    sigla_uf,
    nome_fabricante_vacina,
    COUNT(DISTINCT lote_vacina) AS total_lotes,
    COUNT(1)                    AS total_doses
FROM basedosdados.br_ms_vacinacao_covid19.microdados
GROUP BY sigla_uf, nome_fabricante_vacina
ORDER BY sigla_uf, total_doses DESC;
