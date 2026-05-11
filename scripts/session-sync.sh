#!/usr/bin/env bash
# Sincronização Segura de Contexto (/session-sync)
# Usado automaticamente pelo /session-end ou manualmente.

set -e

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
TARGET_DIR="${PWD}"
SESSION_DIR="${TARGET_DIR}/.agent/session"
GUARD_SCRIPT="${KIT_DIR}/scripts/lib_sync_guard.py"

SUMMARY="${1:-Atualização de contexto via session-sync}"
DATE_STR=$(date "+%Y-%m-%d %H:%M:%S")

echo "🔄 Iniciando sincronização segura de contexto..."

if [ ! -d "$SESSION_DIR/.git" ]; then
    echo "❌ Erro: .agent/session não é um repositório git."
    exit 1
fi

echo "🛡️ Acionando Porteiro de Concorrência..."
if ! python3 "$GUARD_SCRIPT" --action check --session-dir "$SESSION_DIR"; then
    echo "🚨 SINCRONIZAÇÃO ABORTADA 🚨"
    echo "Motivo: Divergência de ETag detectada. O remoto foi alterado desde o início da sua sessão."
    echo "👉 Execute: bash kit/scripts/session-resolve.sh"
    exit 1
fi

echo "✅ ETag Validado. Preparando commit..."

cd "$SESSION_DIR"

# Adicionar todas as mudanças (incluindo SESSION_HISTORY.md)
git add .

# Se não houver mudanças
if git diff --staged --quiet; then
    echo "⚠️ Nenhuma mudança detectada no contexto para sincronizar."
    exit 0
fi

COMMIT_MSG="[${DATE_STR}] ${SUMMARY}"
git commit -m "$COMMIT_MSG"

echo "☁️ Fazendo push para origin/main..."
if git push origin main; then
    echo "✅ Contexto atualizado na nuvem com sucesso!"
    # Atualiza o lock para a nova data
    python3 "$GUARD_SCRIPT" --action update --session-dir "$SESSION_DIR"
else
    echo "❌ Falha no push (possível problema de rede ou permissão)."
    exit 1
fi
