#!/usr/bin/env bash
# Script de Instalação do Kit de Agentes
# Inicializa o kit no diretório alvo através de symlinks e prepara o controle de sessão.

set -e

# Descobrir diretório do kit
KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
TARGET_DIR="${PWD}"

AGENT_DIR="${TARGET_DIR}/.agent"
SESSION_DIR="${AGENT_DIR}/session"

echo "🚀 Iniciando instalação do Kit de Agentes no projeto: $(basename "${TARGET_DIR}")"

# Verifica se a pasta .agent já existe
if [ -d "$AGENT_DIR" ]; then
    echo "⚠️ Diretório .agent já existe."
    echo "🔄 Invocando validate-kit.py como fallback..."
    python3 "$KIT_DIR/scripts/validate-kit.py" --target "$TARGET_DIR"
    exit 0
fi

# Criação da estrutura e symlinks
echo "📦 Criando infraestrutura .agent..."
mkdir -p "$AGENT_DIR"

for item in agents rules skills workflows templates scripts; do
    if [ -d "$KIT_DIR/$item" ]; then
        ln -s "$KIT_DIR/$item" "$AGENT_DIR/$item"
        echo "   🔗 Symlink criado: $item -> $KIT_DIR/$item"
    fi
done

# Configuração do Contexto Desconectado (Nested Git)
echo "📂 Configurando repositório de sessão isolado..."
mkdir -p "$SESSION_DIR"

if [ ! -d "$SESSION_DIR/.git" ]; then
    cd "$SESSION_DIR"
    git init > /dev/null
    git branch -M main 2>/dev/null || true
    echo "# Contexto de Sessão" > CONTEXT.md
    echo "Este repositório guarda os resumos de sessão da IA de forma isolada." > README.md
    git add . > /dev/null
    git commit -m "chore: initial session context repository" > /dev/null
    cd "$TARGET_DIR"
    echo "   ✅ Repositório local de sessão inicializado."
else
    echo "   ✅ Repositório de sessão já existia."
fi

# Isolamento no .gitignore principal
GITIGNORE_FILE="${TARGET_DIR}/.gitignore"
if [ ! -f "$GITIGNORE_FILE" ]; then
    touch "$GITIGNORE_FILE"
fi

if ! grep -q "\.agent/session" "$GITIGNORE_FILE"; then
    echo "" >> "$GITIGNORE_FILE"
    echo "# Ignorar contexto de sessão da IA (repósitorio aninhado isolado)" >> "$GITIGNORE_FILE"
    echo ".agent/session/" >> "$GITIGNORE_FILE"
    echo ".agent/session/*" >> "$GITIGNORE_FILE"
    echo "   🔒 .agent/session protegido e adicionado ao .gitignore do projeto."
fi

# Invocando validação final
echo "🔍 Rodando validação final..."
python3 "$KIT_DIR/scripts/validate-kit.py" --target "$TARGET_DIR"

echo ""
echo "🎉 Instalação concluída com sucesso!"
echo "👉 DICA: Use /session-start para testar a ativação do agente."
