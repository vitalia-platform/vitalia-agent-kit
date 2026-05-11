---
description: >
  Inicia sessão de trabalho recuperando contexto completo do projeto. 
  Apresenta estado atual, últimas atividades e próximo passo prioritário.
  Use ao começar qualquer sessão de trabalho.
---

# /session-start — Início de Sessão

$ARGUMENTS

---

## Propósito

Elimina o cold start de cada sessão. Em segundos você sabe exatamente onde o projeto está e o que fazer a seguir.

---

## Comportamento

Quando `/session-start` for acionado:

### Passo 1: Validar Ambiente e Sincronia (Obrigatório)

```
Execute o script de validação para checar integridade e conflitos de contexto:
$ python3 .agent/scripts/validate-kit.py --target .
```

**Se houver conflito de ETag (Remoto mais novo que o local):**
```
Pare imediatamente e oriente o usuário a resolver o conflito:
$ bash .agent/scripts/session-resolve.sh
Aguarde a resolução antes de prosseguir.
```

### Passo 2: Localizar contexto

```
Buscar: <workspace-root>/.agent/session/CONTEXT.md
```

**Se não existe:**
```
"📋 Projeto sem contexto registrado.
Vou criar o arquivo inicial. Me diga:
1. Nome do projeto:
2. Objetivo em uma frase:
3. O que está sendo desenvolvido agora:
4. Próximo item prioritário:"

→ Detectar automaticamente: stack, tipo, branch (via git)
→ Criar .agent/session/CONTEXT.md
```

**Se existe:** seguir Passo 2.

### Passo 2: Processar e apresentar resumo

```markdown
---

## 📍 [Nome do Projeto] — Sessão Iniciada

**Status**: [status do projeto]
**Branch**: [branch-name]
**Última sessão**: [data] — [X dias/horas atrás]

### ✅ Concluído recentemente
[lista dos últimos 3-5 itens concluídos]

### 🎯 Próximo passo (P0 — mais prioritário)
**[descrição clara do próximo item]**

### 📌 Outros pendentes
- P1: [item]
- P2: [item]

### ⚠️ Constraints ativos
[lista de regras/restrições em vigor para este projeto]

---
**Deseja continuar com o item P0, ou tem outro foco para hoje?**
```

### Passo 3: Preparar ambiente

Após o usuário confirmar o foco:
- Listar os arquivos principais envolvidos
- Verificar se há especialista científico relevante para o foco de hoje
- Ativar `coder` ou `conductor` conforme o foco

---

## Exemplos de Uso

```
/session-start
/session-start vitalia-01
/session-start --foco="endpoint de biometria"
```

---

## Saída Esperada

- Resumo claro do estado do projeto
- Próximo passo definido
- Ambiente preparado para trabalhar imediatamente
