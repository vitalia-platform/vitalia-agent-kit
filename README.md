# Vitalia Agent Kit

> **Uma agência de IA portátil para plataformas de saúde & wellness.**  
> Agentes especialistas que trabalham em equipe — desenvolvem código, revisam ciência, gerenciam contexto e se expandem conforme o projeto cresce.

---

## O que é

O Vitalia Agent Kit é uma coleção de agentes de IA, skills e workflows projetada para ser instalada em qualquer projeto via **git submodule**. Ele implementa **Smart Routing** automático: a intenção do desenvolvedor é analisada em tempo real para acionar o especialista certo — sem nomeação explícita.

**Projetado para:**
- Plataformas de saúde, wellness & longevidade
- Times que combinam engenharia de software e expertise científica
- Qualquer projeto que exija rigor clínico + velocidade de desenvolvimento

---

## Instalação

### Pré-requisito
O kit é compatível com o **Antigravity (Gemini CLI)**. Qualquer ferramenta que suporte arquivos `.agent/` pode ser adaptada.

### Passo 1 — Adicionar como submódulo

```bash
# Na raiz do seu projeto:
git submodule add https://github.com/vitalia-platform/vitalia-agent-kit.git kit
git submodule update --init --recursive
```

### Passo 2 — Instalar (criar symlinks e repositório de sessão)

```bash
bash kit/scripts/install.sh
```

Este script cria o diretório `.agent/` com symlinks para o kit e inicializa o repositório isolado de contexto de sessão.

### Passo 3 — Ativar

Abra o projeto no Antigravity e execute:
```
/session-start
```

### Atualizar o kit

```bash
git submodule update --remote kit
```

---

## Estrutura

```
kit/
├── agents/               # Especialistas por domínio
│   ├── dev/              # Time de desenvolvimento (5 agentes)
│   ├── science/          # Especialistas científicos (9 agentes)
│   └── meta/             # Agentes de meta-trabalho (3 agentes)
├── skills/               # Conhecimento modular reutilizável
│   ├── core/             # Arquitetura, roteamento, contexto
│   ├── dev/              # Padrões de código e engenharia
│   └── science/          # Protocolos clínicos e evidência
├── workflows/            # Slash commands (/session-start, /pair, etc.)
├── rules/                # Regras automáticas (always-on e file-triggered)
├── scripts/              # install.sh, validate-kit.py
└── templates/            # Templates de projeto
```

---

## Agentes disponíveis (17)

### 🛠️ Dev (5)
| Agente | Especialidade |
|--------|--------------|
| `conductor` | Orquestração full-stack e tarefas multi-domínio |
| `coder` | Implementação limpa e resolução de bugs |
| `reviewer` | Code review com foco em segurança e padrões |
| `tester` | TDD, automação e cobertura de testes |
| `shipper` | Deploy, CI/CD e release management |

### 🔬 Science (9)
| Agente | Especialidade |
|--------|--------------|
| `biologist` | Fisiologia, anatomia, imunologia e cronobiologia |
| `endocrinologist` | Hormônios, metabolismo e biomarcadores endócrinos |
| `exercise-physiologist` | Prescrição de exercício, VO₂max e zonas de treino |
| `longevity-specialist` | Aging, epigenética e protocolos de longevidade |
| `nutritionist` | Nutrição baseada em evidência e segurança alimentar |
| `psychologist` | Neurociência comportamental e mudança de hábitos |
| `research-analyst` | Análise de literatura e parceiro de pair science/dev |
| `sleep-specialist` | Medicina do sono e cronobiologia aplicada |
| `supplement-pharmacologist` | Suplementação, dosagens e interações (HITL crítico) |

### ⚙️ Meta (3)
| Agente | Especialidade |
|--------|--------------|
| `bootstrapper` | Inicializa projetos do zero com estrutura padronizada |
| `knowledge-curator` | Extrai aprendizados e cria novos componentes |
| `session-manager` | Mantém e protege o estado do projeto entre sessões |

---

## Workflows

| Comando | Quando usar |
|---------|-------------|
| `/session-start` | Ao iniciar — recupera contexto completo do projeto |
| `/session-end` | Ao encerrar — salva estado e sincroniza na nuvem |
| `/continue [feature]` | Retoma código específico com contexto cirúrgico |
| `/pair [objetivo]` | Pair programming chunk-a-chunk com aprovação humana |
| `/science-review [feature]` | Revisão científica antes de publicar conteúdo de saúde |
| `/adr` | Registra decisão arquitetural de forma interativa |
| `/bootstrap` | Inicializa projeto do zero |
| `/release` | Prepara changelog, versionamento e tag |

---

## Segurança & HITL

O kit implementa **Human-in-the-Loop (HITL)** obrigatório para conteúdo clínico:

```
IA gera → DRAFT
Especialista científico revisa → REVIEW
Profissional de saúde humano aprova → ACTIVE (pode ir para produção)
```

Regras always-on: `hitl-medical`, `session-context`, `smart-routing`.

---

## Gestão de Contexto entre Sessões

O kit usa um modelo **Nested Git** para persistir contexto sem poluir o repositório principal:

- `.agent/session/` é um repositório Git **independente** (gitignored no projeto)
- Contexto pode ser sincronizado com qualquer repositório remoto privado
- Controle otimista de concorrência via ETags para uso em múltiplas máquinas

---

## Changelog

### v0.2.0 — 2026-05-11
- ✨ 5 novos agentes science: `exercise-physiologist`, `longevity-specialist`, `research-analyst`, `sleep-specialist`, `supplement-pharmacologist`
- 📝 MANUAL.md atualizado com catálogo completo
- 🔄 Estrutura preparada para distribuição como repositório independente

### v0.1.0 — 2026-04-30
- 🎉 Release inicial
- 12 agentes, 11 skills, 8 workflows, 6 rules
- `install.sh` e `validate-kit.py` funcionais
- Integração científica com HITL e RAG protocol

---

## Licença

MIT — use, modifique e distribua livremente.  
Contribuições bem-vindas via Pull Request.
