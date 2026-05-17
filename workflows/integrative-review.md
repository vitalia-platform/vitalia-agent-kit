# Workflow: Integrative Review (`/integrative-review`)

**Description**: The master workflow to initiate, structure, and orchestrate a rigorous academic Systematic or Integrative Literature Review. This workflow creates the necessary templates, conducts Socratic alignment, and triggers the Science Agent Squad (`chief-reviewer`, `data-librarian`, `methodology-auditor`).

---

## 1. Fase Exploratória (Socratic Questioning)
Quando o usuário acionar o comando `/integrative-review`, **PARE E PERGUNTE** os seguintes pontos para definir o escopo antes de gerar os templates:

1. **Pergunta Norteadora (PICO/PCC)**: Qual é a exata pergunta científica que a revisão pretende responder? 
2. **Critérios Macro de Inclusão**: Qual o recorte temporal (ex: 2020-2026)? Quais tipos de estudo serão aceitos (ex: RCTs, Meta-análises)?
3. **Bases de Dados Alvo**: Onde a extração primária será conduzida? (Aconselhe Scopus e Web of Science via acesso RNP/Institucional, desencoraje Pubmed direto se o volume for altíssimo).

## 2. Inicialização do Ambiente ("Clean Room")
Após a aprovação do escopo:
- Crie o `00_SUMARIO_EXECUTIVO.md` contendo a Pergunta Norteadora definida.
- Crie a pasta `exportacao/` e exija que o usuário deposite o arquivo `.csv` bruto da base de dados selecionada nela.

## 3. Disparo da Orquestração
Assim que o arquivo `.csv` estiver depositado:
1. **Acione o `@data-librarian`**: Instrua-o a processar o CSV bruto usando a skill `academic-id-resolver` para garantir que as chaves primárias (DOIs) sejam limpas, e a preparar o template `PRISMA_LOG.csv`.
2. **Acione o `@chief-reviewer`**: Entregue o pipeline para ele. O *Chief* deverá rodar o screening da Fase 1, delegando a leitura massiva para o `research-analyst` e enviando os resultados para o `methodology-auditor`.

## Anti-Pattern 🚫
- NUNCA inicie a triagem de artigos de forma aleatória pegando abstracts do Google. Siga a exportação metodológica do portal.
- NUNCA pule a auditoria de exclusão do PRISMA (Log Total). Todo artigo tem que ter o motivo explícito da exclusão anotado.
