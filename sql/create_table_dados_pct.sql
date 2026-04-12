CREATE OR REPLACE TABLE base_dados_covid19_vacinacao.dados_pct AS 

SELECT
    -- Evento de vacinacao
    microdados.id_paciente,
    microdados.data_aplicacao_vacina,
    microdados.dose_vacina,
    microdados.nome_fabricante_vacina,
    microdados.sigla_uf                      AS uf_vacinacao,

    -- Estabelecimento
    microdados.id_estabelecimento,
    microdados.razao_social_estabelecimento,

    -- Dados do paciente (campo exclusivo da tabela paciente)
    pacientes.sigla_uf_endereco             AS uf_endereco_paciente,
    pacientes.sexo,
    pacientes.idade,
    pacientes.raca_cor,
    pacientes.id_municipio_endereco,
    pacientes.nacionalidade

FROM basedosdados.br_ms_vacinacao_covid19.microdados AS microdados
LEFT JOIN basedosdados.br_ms_vacinacao_covid19.microdados_paciente AS pacientes
  ON microdados.id_paciente = pacientes.id_paciente



