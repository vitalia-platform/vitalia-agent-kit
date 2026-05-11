#!/usr/bin/env bash
# Resolução de Conflitos do Contexto (/session-resolve)
# Usado quando o ETag do remoto não bate com o local.

set -e

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
TARGET_DIR="${PWD}"
SESSION_DIR="${TARGET_DIR}/.agent/session"
GUARD_SCRIPT="${KIT_DIR}/scripts/lib_sync_guard.py"

echo "🚨 MODO DE RESOLUÇÃO DE CONFLITO ATIVADO 🚨"
echo "O repositório remoto possui informações mais novas que a sua sessão local."
echo ""
echo "Escolha como deseja resolver esta divergência:"
echo "1) Fazer PULL e tentar fazer MERGE (Preserva o remoto e junta com o seu local)"
echo "2) SOBRESCREVER o remoto (Força o envio do seu contexto local, APAGA as mudanças remotas)"
echo "3) RECRIAR REPOSITÓRIO GIT (Usado se a pasta .git foi apagada acidentalmente)"
echo "4) ABORTAR (Não fazer nada por enquanto)"
echo ""
read -p "Digite a opção (1/2/3/4): " opcao

cd "$SESSION_DIR"

if [ "$opcao" == "1" ]; then
    echo "⬇️ Iniciando Pull / Merge..."
    # Configura para merge standard caso não esteja configurado
    git config pull.rebase false
    if git pull origin main; then
        echo "✅ Pull efetuado com sucesso."
        echo "🔄 Atualizando porteiro de sincronia..."
        python3 "$GUARD_SCRIPT" --action update --session-dir "$SESSION_DIR"
        echo "Tudo resolvido. Você pode continuar trabalhando ou rodar session-sync novamente."
    else
        echo "⚠️ Ocorreu um conflito de merge automático no arquivo CONTEXT.md."
        echo "👉 Por favor, abra .agent/session/CONTEXT.md, resolva as tags de conflito, faça o commit e rode session-sync."
    fi

elif [ "$opcao" == "2" ]; then
    echo "⚠️ Tem certeza que deseja APAGAR o contexto remoto mais recente?"
    read -p "Digite 'sim' para confirmar: " confirm
    if [ "$confirm" == "sim" ]; then
        echo "⬆️ Forçando push local para o remoto..."
        # Certifica-se de que as mudanças locais estão commitadas antes do force push
        git add .
        git diff --staged --quiet || git commit -m "chore: force overwrite local context"
        if git push -f origin main; then
            echo "✅ Sobrescrita concluída com sucesso!"
            python3 "$GUARD_SCRIPT" --action update --session-dir "$SESSION_DIR"
        else
            echo "❌ Falha ao tentar forçar o push."
        fi
    else
        echo "Operação cancelada."
    fi

elif [ "$opcao" == "3" ]; then
    echo "🔨 Recriando a estrutura Git em .agent/session..."
    git init
    git branch -M main 2>/dev/null || true
    git add .
    git commit -m "chore: recriacao do repositorio de contexto"
    echo ""
    echo "✅ Estrutura local recriada."
    echo "⚠️ ATENÇÃO: Como o repositório foi recriado, você precisará reconectá-lo ao remoto."
    echo "Comando sugerido: git remote add origin <URL>"
    echo "E depois rode: bash kit/scripts/session-resolve.sh e escolha a opção 2 (Sobrescrever) para forçar sua estrutura nova para a nuvem."

elif [ "$opcao" == "4" ]; then
    echo "Operação abortada."
else
    echo "Opção inválida."
fi
