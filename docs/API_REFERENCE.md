# API Reference - AgGenie

Referência completa da API do ActiveGenie Microservice.

## Base URL

```
http://localhost:4567
```

Para Docker:
```
http://activegenie:4567
```

---

## Endpoints

### `GET /health`

Health check do serviço.

**Response:**
```json
{
  "status": "ok",
  "timestamp": "2026-04-15T12:00:00Z"
}
```

---

### `GET /`

Informações do serviço.

**Response:**
```json
{
  "service": "AgGenie - ActiveGenie Microservice",
  "version": "1.0.0",
  "endpoints": ["/health", "/api/v1/compare", ...]
}
```

---

## POST /api/v1/compare

Compara duas opções e determina um vencedor com reasoning estruturado.

### Request

```json
{
  "player_a": "Opção A - descrição",
  "player_b": "Opção B - descrição",
  "criteria": "critério1, critério2, critério3",
  "provider": "openai",
  "model": "gpt-4"
}
```

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `player_a` | string | ✅ | Primeira opção |
| `player_b` | string | ✅ | Segunda opção |
| `criteria` | string | ✅ | Critérios de avaliação separados por vírgula |
| `provider` | string | ❌ | Provider: `openai`, `anthropic`, `google` (default: openai) |
| `model` | string | ❌ | Modelo específico do provider |

### Response

```json
{
  "success": true,
  "data": {
    "winner": "Opção A",
    "loser": "Opção B",
    "reasoning": "A opção A vence porque..."
  },
  "meta": {
    "provider": "openai",
    "model": "gpt-4"
  }
}
```

### Exemplo curl

```bash
curl -X POST http://localhost:4567/api/v1/compare \
  -H 'Content-Type: application/json' \
  -d '{
    "player_a": "Usar Redis para cache",
    "player_b": "Usar PostgreSQL com materialized view",
    "criteria": "performance, custo, manutibilidade"
  }'
```

---

## POST /api/v1/score

Avalia conteúdo com um jury de especialistas.

### Request

```json
{
  "content": "Conteúdo a avaliar",
  "criteria": "critério1, critério2",
  "reviewers": ["especialista1", "especialista2"],
  "provider": "openai",
  "model": "gpt-4"
}
```

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `content` | string | ✅ | Conteúdo a avaliar |
| `criteria` | string | ✅ | Critérios de avaliação |
| `reviewers` | array | ❌ | Nomes dos reviewers (opcional) |
| `provider` | string | ❌ | Provider: `openai`, `anthropic`, `google` (default: openai) |
| `model` | string | ❌ | Modelo específico do provider |

### Response

```json
{
  "success": true,
  "data": {
    "scores": {
      "clarity_score": 8,
      "completeness_score": 7
    },
    "reasonings": {
      "clarity_reasoning": "...",
      "completeness_reasoning": "..."
    },
    "final_score": 7.5
  },
  "meta": {
    "provider": "openai",
    "model": "gpt-4"
  }
}
```

### Exemplo curl

```bash
curl -X POST http://localhost:4567/api/v1/score \
  -H 'Content-Type: application/json' \
  -d '{
    "content": "Tutorial de instalação do sistema...",
    "criteria": "clareza, completude, utilidade"
  }'
```

---

## POST /api/v1/rank

Ranqueia múltiplas opções usando tournament + ELO.

### Request

```json
{
  "items": ["item1", "item2", "item3"],
  "criteria": "critério1, critério2",
  "provider": "openai",
  "model": "gpt-4"
}
```

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `items` | array | ✅ | Array de strings com pelo menos 2 elementos |
| `criteria` | string | ✅ | Critérios de ranqueamento |
| `provider` | string | ❌ | Provider: `openai`, `anthropic`, `google` (default: openai) |
| `model` | string | ❌ | Modelo específico do provider |

### Response

```json
{
  "success": true,
  "data": {
    "rankings": [
      {"rank": 1, "item": "item2", "score": 9.2, "elo": 1500},
      {"rank": 2, "item": "item1", "score": 8.1, "elo": 1450},
      {"rank": 3, "item": "item3", "score": 7.0, "elo": 1400}
    ],
    "winner": "item2",
    "total_items": 3
  },
  "meta": {
    "provider": "openai",
    "model": "gpt-4"
  }
}
```

### Exemplo curl

```bash
curl -X POST http://localhost:4567/api/v1/rank \
  -H 'Content-Type: application/json' \
  -d '{
    "items": ["PostgreSQL", "MySQL", "MongoDB"],
    "criteria": "performance, popularidade, facilidade"
  }'
```

---

## POST /api/v1/extract

Extrai dados estruturados de texto não estruturado.

### Request

```json
{
  "text": "Texto não estruturado",
  "schema": {
    "campo1": "tipo",
    "campo2": "tipo"
  },
  "provider": "openai",
  "model": "gpt-4"
}
```

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `text` | string | ✅ | Texto de origem |
| `schema` | object | ✅ | Schema de extração |
| `provider` | string | ❌ | Provider: `openai`, `anthropic`, `google` (default: openai) |
| `model` | string | ❌ | Modelo específico do provider |

### Response

```json
{
  "success": true,
  "data": {
    "name": "João Silva",
    "age": 35,
    "city": "São Paulo"
  },
  "meta": {
    "provider": "openai",
    "model": "gpt-4"
  }
}
```

### Exemplo curl

```bash
curl -X POST http://localhost:4567/api/v1/extract \
  -H 'Content-Type: application/json' \
  -d '{
    "text": "João Silva, 35 anos, mora em São Paulo",
    "schema": {
      "name": "string",
      "age": "number",
      "city": "string"
    }
  }'
```

---

## POST /api/v1/debate

Debate entre múltiplos agentes com Comparator como árbitro.

### Request

```json
{
  "topic": "Pergunta/tópico do debate",
  "arguments": [
    {
      "agent": "NomeAgente1",
      "position": "Posição do agente 1",
      "reasoning": "Justificativa (opcional)"
    },
    {
      "agent": "NomeAgente2",
      "position": "Posição do agente 2",
      "reasoning": "Justificativa (opcional)"
    }
  ],
  "criteria": "critério1, critério2",
  "provider": "openai",
  "model": "gpt-4"
}
```

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `topic` | string | ✅ | Tópico do debate |
| `arguments` | array | ✅ | Array com pelo menos 2 argumentos |
| `criteria` | string | ✅ | Critérios de avaliação |
| `provider` | string | ❌ | Provider: `openai`, `anthropic`, `google` (default: openai) |
| `model` | string | ❌ | Modelo específico do provider |

### Response

```json
{
  "success": true,
  "data": {
    "topic": "Qual cache usar?",
    "winner": "Position 2 (HAL)",
    "loser": "Position 1 (Woz)",
    "reasoning": "Cloudflare Workers KV wins because...",
    "arguments_submitted": 2,
    "debate_format": "structured_comparison"
  },
  "meta": {
    "provider": "openai",
    "model": "gpt-4"
  }
}
```

### Exemplo curl

```bash
curl -X POST http://localhost:4567/api/v1/debate \
  -H 'Content-Type: application/json' \
  -d '{
    "topic": "Qual tecnologia usar para cache?",
    "arguments": [
      {
        "agent": "Woz",
        "position": "Redis",
        "reasoning": "Ecossistema maduro"
      },
      {
        "agent": "HAL",
        "position": "Cloudflare KV",
        "reasoning": "Global por default"
      }
    ],
    "criteria": "performance, custo, operacional"
  }'
```

---

## Códigos de Erro

| Código | Significado |
|--------|-------------|
| 200 | Success |
| 400 | Parâmetros obrigatórios faltando ou inválidos |
| 500 | Erro interno do ActiveGenie ou do provider |

### Formato de Erro

```json
{
  "error": "Missing required parameters",
  "required": ["player_a", "player_b", "criteria"],
  "received": ["player_a"]
}
```

---

## Autenticação

O serviço usa API keys via variáveis de ambiente:

```bash
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GOOGLE_API_KEY="..."
```

---

## Rate Limits

| Provider | Limite |
|----------|--------|
| OpenAI | 500 requests/mês (free tier) |
| Anthropic | Varia por plano |
| Google | Varia por plano |

Considere implementar caching para requisições repetidas.
