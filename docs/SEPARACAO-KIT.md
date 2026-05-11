# Guia: Separar o Kit da Plataforma Vitalia

> Como extrair o `kit/` para um repositório GitHub independente e reconectá-lo ao projeto como git submodule.

---

## Contexto

Atualmente o kit vive dentro do repositório `vitalia-01` no diretório `kit/`. O objetivo é:

1. Publicá-lo como repositório GitHub independente (`vitalia-agent-kit`)
2. Reconectá-lo ao `vitalia-01` como **git submodule**
3. Qualquer projeto futuro pode instalar o kit com `git submodule add`

---

## Pré-requisitos

- Acesso ao GitHub (conta ou organização onde o repo será criado)
- Git configurado localmente com as credenciais corretas

---

## Passo 1 — Criar o repositório no GitHub

Acesse o GitHub e crie um novo repositório:

- **Nome sugerido**: `vitalia-agent-kit`
- **Visibilidade**: Public (para instalação por outros projetos) ou Private
- **NÃO inicialize com README** (o kit já tem o seu)

Anote a URL do repositório. Exemplo:
```
git@github.com:vitalia-platform/vitalia-agent-kit.git
```

---

## Passo 2 — Inicializar o kit como repositório Git independente

```bash
cd /home/andre/projetos/assistidos/vitalia-01/kit

# Inicializar como repositório independente
git init
git branch -M main

# Conectar ao repositório remoto criado no GitHub
git remote add origin git@github.com:vitalia-platform/vitalia-agent-kit.git

# Primeiro commit com todo o conteúdo atual do kit
git add .
git commit -m "feat: initial release v0.2.0

- 17 agentes (5 dev + 9 science + 3 meta)
- 11 skills, 8 workflows, 6 rules
- HITL, Smart Routing, Nested Git session management
- GitHub Actions CI para validação de estrutura"

# Push para o GitHub
git push -u origin main
```

---

## Passo 3 — Remover o kit do tracking do vitalia-01

De volta à raiz do projeto `vitalia-01`:

```bash
cd /home/andre/projetos/assistidos/vitalia-01

# Remover kit/ do índice do git (sem deletar os arquivos)
git rm -r --cached kit/

# Commit registrando a extração
git commit -m "chore: extract kit to standalone repository vitalia-agent-kit

O kit de agentes foi extraído para repositório independente.
Será reconectado como git submodule no próximo commit."
```

---

## Passo 4 — Adicionar o kit como git submodule

```bash
# Adicionar o kit como submodule (na mesma posição kit/)
git submodule add git@github.com:vitalia-platform/vitalia-agent-kit.git kit

# Confirmar
git commit -m "chore: add vitalia-agent-kit as git submodule

Instalar em nova máquina:
  git submodule update --init --recursive
  bash kit/scripts/install.sh"

git push
```

---

## Passo 5 — Verificar que tudo funciona

```bash
# Verificar submodule configurado corretamente
cat .gitmodules

# Reinstalar os symlinks
bash kit/scripts/install.sh

# Validar kit
python3 .agent/scripts/validate-kit.py --target .
```

Saída esperada: `🟢 KIT AUDITADO E PRONTO PARA USO.`

---

## Instalação em um novo projeto (após a separação)

Qualquer projeto novo instala o kit assim:

```bash
# 1. Adicionar como submodule
git submodule add git@github.com:vitalia-platform/vitalia-agent-kit.git kit

# 2. Instalar symlinks e session repo
bash kit/scripts/install.sh

# 3. Ativar no Antigravity
# /session-start
```

---

## Atualizar o kit em projetos existentes

```bash
# Puxar a última versão do kit
git submodule update --remote kit

# Revalidar
python3 .agent/scripts/validate-kit.py --target .
```

---

## Resultado Final

```
vitalia-agent-kit/   ← repositório independente no GitHub
    └── (kit completo: agentes, skills, workflows, rules, scripts)

vitalia-01/          ← plataforma, referencia o kit como submodule
    ├── kit/         ← git submodule → vitalia-agent-kit
    ├── .agent/      ← symlinks para kit/ (gitignored)
    └── ... (código da plataforma)
```
