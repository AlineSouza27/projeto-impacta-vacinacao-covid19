# 💉 Analytics de Vacinação COVID-19 (2020-2021)

## 📌 Descrição do projeto

Este repositório reúne o projeto de Analytics Engineering para análise de dados de vacinação contra COVID-19 no Brasil (2020-2021), usando dados oficiais da Base dos Dados hospedados no Google Cloud Platform (BigQuery).

O objetivo é construir um dashboard com 4 abas que forneça visão macro e detalhes por vacinação, paciente e estabelecimento, apoiando tomadas de decisão em saúde pública.

---

## 🏗️ Arquitetura de Dados

- Plataforma: **Google Cloud Platform (GCP)**
- Data Warehouse: **BigQuery**
- Projeto público de dados: `basedosdados`
- Dataset: `br_ms_vacinacao_covid19`

### Tabelas/views principais
- `microdados`
- `microdados_estabelecimento`
- `microdados_paciente`
- `microdados_vacinacao`
- Dicionário de dados (metadados de variáveis)

### Fluxo Analítico Proposto
1. Consumo direto das tabelas BigQuery de `basedosdados`.
2. Transformações SQL (views modeladas) para geração de métricas.
3. Criação de dashboards em ferramenta de BI.
4. Entrega de visão analítica com atualização periódica.

---

## 📚 Dicionário de Visões (4 Views)

1. **Macro (visão geral)**
   - Métricas agregadas de doses aplicadas, cobertura e evolução temporal.
   - Agrupamentos por dia/mês, UF, região e dose.

2. **Vacinação (detalhamento da vacinação)**
   - Indicadores por tipo de dose (1ª, 2ª, dose de reforço).
   - Quantidade aplicada por fabricante, idade e local.

3. **Paciente (detalhamento de perfil)**
   - Perfil dos pacientes vacinados (idade, sexo, raça, comorbidade).
   - Taxas de cobertura e distribuição por grupos demográficos.

4. **Estabelecimento (detalhamento de ponto de aplicação)**
   - Performance por estabelecimento/município.
   - Volumes aplicados e comparativo de produtividade local.

---

## 🎯 Escopo do Dashboard (4 abas)

### 1) Macro (Visão Geral)
- KPIs principais: total de doses, média diária, cobertura por população.
- Gráficos de tendência de doses e mapas de calor por região.
- Indicadores de progressão mensal.

### 2) Detalhamento: Vacinação
- Distribuição de doses por vacina (CoronaVac, AstraZeneca, Pfizer, Janssen etc.).
- Comparativo de doses por período e classe de dose (1ª, 2ª, reforço).
- Séries temporais por UF/município.

### 3) Detalhamento: Paciente
- Segmentação por faixa etária, sexo, raça e comorbidade.
- Indicadores de disproporção e diferentes coberturas entre grupos.
- Painel de prioridades e grupos vulneráveis.

### 4) Detalhamento: Estabelecimento
- Ranking de estabelecimentos por volume de aplicações.
- Indicadores de eficiência e produção por localidade.
- Análise de saturação e atendimento por município/região.

---

## 🛠️ Tecnologias sugeridas

- **SQL (BigQuery SQL)** para modelagem e derivação de métricas.
- **Python** (pandas, dbt, scripts de validação) para análises e automações.
- **Ferramentas de BI**: Looker Studio, Power BI, Tableau ou Metabase.

> Recomendado: utilizar **dbt** para versionar as transformações e garantir governança de código.

---

## ▶️ Como reproduzir o acesso aos dados via SQL (BigQuery)

### 1) Acesse o BigQuery
1. Acesse: https://console.cloud.google.com/bigquery
2. Abra o projeto público: `basedosdados`
3. Navegue até o dataset `br_ms_vacinacao_covid19`

### 2) Exemplo de join com paciente
```sql
SELECT
  v.data_aplicacao,
  p.idade,
  p.sexo,
  v.nome_fabricante,
  COUNT(1) AS total_doses
FROM
  `basedosdados.br_ms_vacinacao_covid19.microdados_vacinacao` v
JOIN
  `basedosdados.br_ms_vacinacao_covid19.microdados_paciente` p
  ON v.id_paciente = p.id_paciente -- ajuste para chave correta
WHERE
  v.data_aplicacao BETWEEN '2020-01-01' AND '2021-12-31'
GROUP BY
  v.data_aplicacao, p.idade, p.sexo, v.nome_fabricante
ORDER BY
  v.data_aplicacao DESC
LIMIT 100;
```

---

## ✅ Checklist de atividades por aba
- [x] Macro (Visão Geral): consolidar KPIs e confirmar a modelagem de métricas macro.
- [ ] Detalhamento: Vacinação – elaborar query/view de doses por tipo, fabricante, idade e UF.
- [ ] Detalhamento: Paciente – criar query/view de perfil/população vacinada (idade, sexo, raça, comorbidade).
- [ ] Detalhamento: Estabelecimento – implementar query/view por unidade/município e volume de doses.

---

## ✅ Próximos passos
1. Valide as colunas no dicionário de dados.
2. Crie views para cada aba do dashboard (macro, vacinação, paciente, estabelecimento).
3. Conecte a ferramenta de BI diretamente ao BigQuery.
4. Documente regras de negócio (ex.: definição de cobertura, dose de reforço).

---

## 📎 Referências
- Dataset Base dos Dados: https://basedosdados.org
- BigQuery: https://cloud.google.com/bigquery
- Looker Studio: https://lookerstudio.google.com
