# Workflow: Integrative Review (`/integrative-review`)

**Description**: Ponto de entrada principal para iniciar, estruturar e orquestrar uma Revisão Sistemática ou Integrativa da Literatura. Conduz o pesquisador pelo Painel Interativo de Setup, calibra os critérios com base na amostra, e aciona o Esquadrão Science (`chief-reviewer`, `data-librarian`, `methodology-auditor`).

---

## 1. Fase Exploratória — Painel Interativo de Setup

Quando o usuário acionar `/integrative-review`, **PARE E COLETE** as informações abaixo antes de gerar qualquer artefato. Apresente como um formulário interativo:

### 1.1 Identidade do Estudo
1. **Título provisório** do estudo
2. **Autores e filiação institucional** (para o artigo final)
3. **Periódico alvo** (ex: *JMIR mHealth and uHealth*)
4. **Pergunta Norteadora (PICO/PCC)**: qual é a exata pergunta científica que a revisão pretende responder?
5. **Recorte temporal** (ex: 2020–2026)
6. **Tipos de estudo aceitos** (ex: RCTs, Meta-análises, estudos observacionais)
7. **Bases de dados alvo** — aconselhe Scopus + Web of Science via RNP/Institucional; desencoraje PubMed direto para volumes acima de 10.000 registros

### 1.2 Configuração das Pastas de Trabalho

> [!IMPORTANT]
> Todos os nomes de pasta são definidos aqui. Nenhum valor é fixo no código. Os nomes escolhidos serão gravados em `criteria_config.yaml` e usados por todos os agentes e scripts.

| Finalidade | Nome da pasta (sugestão padrão) |
|---|---|
| CSV bruto da base de dados | `exportacao` |
| Amostra — PDFs (Scopus) | `amostra/scopus` |
| Amostra — CSV (WoS) | `amostra/webofscience` |
| Pool de lotes para triagem em massa | `lotes` |
| Saída PRISMA (logs e resultados) | `saida` |
| Fichamentos (leitura integral) | `fichamentos` |

O pesquisador pode aceitar os nomes padrão ou redefinir cada um.

### 1.3 Infraestrutura de Processamento
- **URL da API Ollama local** (ex: `http://ip-do-servidor:11434`)
- **Modelo de linguagem** (ex: `llama3.2:3b`)
- **Modelo de embeddings** (ex: `nomic-embed-text`)
- **Tamanho do lote** para triagem em massa (ex: `1000`)
- **Domínios de alto valor**: temas de interesse especial → receberão tag `TRENDING_TOPIC`

---

## 2. Inicialização do Ambiente ("Clean Room")

Após aprovação do painel pelo pesquisador:

1. Crie o `00_SUMARIO_EXECUTIVO.md` preenchido com a Pergunta Norteadora e todos os dados coletados acima
2. Crie as pastas de trabalho com os nomes definidos no painel:
   ```bash
   mkdir -p [pasta-exportacao] [pasta-amostra]/scopus [pasta-amostra]/webofscience [pasta-lotes] [pasta-saida] [pasta-fichamentos]
   ```
3. Gere o `criteria_config.yaml` na raiz do projeto com **todos** os parâmetros definidos — este arquivo é o cérebro de todo processamento posterior

---

## 3. Pré-condição de Dados (Aguardar Depósito)

Após criar as pastas, **PARE e instrua o pesquisador**:

```
📥 Ambiente inicializado. Antes de prosseguir, deposite os dados de calibração:

  → [pasta-amostra]/scopus/       — PDFs dos artigos mais relevantes (baixados do Scopus)
  → [pasta-amostra]/webofscience/ — CSV de metadados exportado da Web of Science
  → [pasta-exportacao]/           — CSV bruto completo da busca nas bases

Quando os arquivos estiverem depositados, confirme para iniciar a análise da amostra.
```

---

## 4. Análise da Amostra e Calibração dos Critérios

Após confirmação do depósito:

1. Leia a pasta de amostra (PDFs e CSVs)
2. Mapeie os temas recorrentes
3. **Sugira ativamente** os critérios de Inclusão e Exclusão com base na amostra
4. Permita ao pesquisador:
   - Aprovar as sugestões
   - Modificar critérios pelo chat
   - Fornecer um artigo "Padrão Ouro" para refinamento adicional
5. Grave os critérios aprovados em `criteria_config.yaml`

---

## 5. Disparo da Orquestração

Assim que `criteria_config.yaml` estiver aprovado e os lotes depositados:

1. **Acione o `@data-librarian`**: processar o CSV bruto usando a skill `academic-id-resolver` para limpar DOIs e preparar o `PRISMA_LOG.csv`
2. **Acione o `@chief-reviewer`**: rodar o screening da Fase 1 (título + resumo via Ollama local), delegando leitura massiva ao `research-analyst` e enviando resultados para o `methodology-auditor`

---

## Anti-Patterns 🚫

- **NUNCA** inicie triagem pegando abstracts do Google — siga a exportação metodológica do portal
- **NUNCA** pule o Log Total PRISMA — todo artigo excluído deve ter motivo registrado
- **NUNCA** altere `criteria_config.yaml` manualmente durante o processamento — use o workflow para ajustes
- **NUNCA** hardcode nomes de pasta nos scripts — leia sempre de `criteria_config.yaml`
