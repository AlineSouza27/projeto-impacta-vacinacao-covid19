-- Consultas analíticas para o projeto de vacinação COVID-19 (2020-2021)
-- Base: basedosdados.br_ms_vacinacao_covid19

/********* Consulta 1 ****************/
-- Visão macro de aplicação de doses por mês e por UF
-- Retorna total de doses aplicadas agregadas por mês e estado

SELECT
  DATE_TRUNC(data_aplicacao, MONTH) AS mes,
  uf,
  COUNT(1) AS total_doses,
  SUM(CASE WHEN dose = '1ª Dose' THEN 1 ELSE 0 END) AS total_dose_1,
  SUM(CASE WHEN dose = '2ª Dose' THEN 1 ELSE 0 END) AS total_dose_2,
  SUM(CASE WHEN LOWER(dose) LIKE '%refor%C3%A7o%' THEN 1 ELSE 0 END) AS total_reforco
FROM
  `basedosdados.br_ms_vacinacao_covid19.microdados_vacinacao`
WHERE
  data_aplicacao BETWEEN '2020-01-01' AND '2021-12-31'
GROUP BY
  mes, uf
ORDER BY
  mes, uf;

/********* Consulta 2 ****************/
-- Perfil de pacientes vacinados por faixa etária e sexo
-- Retorna número de registros por faixa etária e sexo, com taxa de cobertura relativa

SELECT
  CASE
    WHEN idade BETWEEN 0 AND 17 THEN '0-17'
    WHEN idade BETWEEN 18 AND 29 THEN '18-29'
    WHEN idade BETWEEN 30 AND 44 THEN '30-44'
    WHEN idade BETWEEN 45 AND 59 THEN '45-59'
    WHEN idade >= 60 THEN '60+'
    ELSE 'NAO INFORMADO'
  END AS faixa_etaria,
  COALESCE(sexo, 'NI') AS sexo,
  COUNT(1) AS total_vacinados,
  ROUND(COUNT(1) / SUM(COUNT(1)) OVER () * 100, 2) AS pct_total
FROM
  `basedosdados.br_ms_vacinacao_covid19.microdados_paciente`
WHERE
  idade IS NOT NULL
GROUP BY
  faixa_etaria, sexo
ORDER BY
  faixa_etaria, sexo;

/********* Consulta 3 ****************/
-- Distribuição de doses por fabricante e tipo de dose
-- Retorna volume total de doses aplicadas por fabricante e tipo, no período de 2020-2021

SELECT
  nome_fabricante,
  dose,
  COUNT(1) AS total_doses,
  ROUND(COUNT(1) / SUM(COUNT(1)) OVER (PARTITION BY dose) * 100, 2) AS pct_por_dose
FROM
  `basedosdados.br_ms_vacinacao_covid19.microdados_vacinacao`
WHERE
  data_aplicacao BETWEEN '2020-01-01' AND '2021-12-31'
GROUP BY
  nome_fabricante, dose
ORDER BY
  dose, total_doses DESC;

/********* Consulta 4 ****************/
-- Ranking de estabelecimentos por número de doses aplicadas
-- Retorna top 50 estabelecimentos com maior volume de aplicação

SELECT
  estab.*,
  COUNT(1) AS total_doses
FROM
  `basedosdados.br_ms_vacinacao_covid19.microdados_vacinacao` v
JOIN
  `basedosdados.br_ms_vacinacao_covid19.microdados_estabelecimento` estab
ON
  v.id_estabelecimento = estab.id_estabelecimento
WHERE
  v.data_aplicacao BETWEEN '2020-01-01' AND '2021-12-31'
GROUP BY
  estab.id_estabelecimento,
  estab.nome_estabelecimento,
  estab.cnes,
  estab.municipio,
  estab.uf
ORDER BY
  total_doses DESC
LIMIT 50;
