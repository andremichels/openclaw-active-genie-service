# Agent Debate Workflow

Workflow para múltiplos agentes discutirem questões com o Comparator como árbitro.

## Overview

O fluxo permite que múltiplos agentes (Woz, HAL, C3PO, R2D2, JARVIS) apresentem suas posições sobre um tópico, e o Comparator avalia e determina o vencedor com reasoning estruturado.

## Fluxo

```
1. Cada agente apresenta seu argumento (position + reasoning)
2. Comparator conduz debate estruturado
3. Retorna winner com reasoning
```

## API Endpoint

```
POST /api/v1/debate
```

## Request

```json
{
  "topic": "Qual tecnologia usar para cache?",
  "arguments": [
    {
      "agent": "Woz",
      "position": "Usar Redis pelo ecossistema maduro",
      "reasoning": "Redis tem toolings completos, replicaçao integrada..."
    },
    {
      "agent": "HAL",
      "position": "Usar Cloudflare Workers KV",
      "reasoning": "Mais simples, globally distributed por default..."
    }
  ],
  "criteria": "performance, custo, operacional, escalabilidade"
}
```

## Response

```json
{
  "success": true,
  "data": {
    "topic": "Qual tecnologia usar para cache?",
    "winner": "Position 2 (HAL)",
    "loser": "Position 1 (Woz)",
    "reasoning": "Cloudflare Workers KV wins because...",
    "arguments_submitted": 2,
    "debate_format": "structured_comparison"
  }
}
```

## Use Cases

### 1. Debate Technology Choice

```bash
curl -X POST http://localhost:4567/api/v1/debate \
  -H 'Content-Type: application/json' \
  -d '{
    "topic": "Redis vs Cloudflare vs PostgreSQL para cache",
    "arguments": [
      {
        "agent": "Woz",
        "position": "Redis: ecossistema maduro, many clients",
        "reasoning": "Largest community, comprehensive documentation"
      },
      {
        "agent": "HAL", 
        "position": "Cloudflare KV: globally distributed, zero config",
        "reasoning": "No infrastructure management, global CDN built-in"
      },
      {
        "agent": "C3PO",
        "position": "PostgreSQL: same DB, no new infra",
        "reasoning": "Avoid new dependencies, use what you have"
      }
    ],
    "criteria": "performance, cost, operational_complexity, scalability"
  }'
```

### 2. Architecture Discussion

```json
{
  "topic": "Microservices vs Monolith para MVP?",
  "arguments": [
    {
      "agent": "Woz",
      "position": "Monolith: faster to build, simpler deployment",
      "reasoning": "MVP precisa de velocidade, não escala"
    },
    {
      "agent": "HAL",
      "position": "Microservices: isolation, team autonomy",
      "reasoning": "Cada serviço pode evoluir independente"
    }
  ],
  "criteria": "development_speed, maintainability, team_size, mvp_timeline"
}
```

### 3. Feature Prioritization

```json
{
  "topic": "Priorizar features para Sprint 1",
  "arguments": [
    {
      "agent": "JARVIS",
      "position": "User auth primeiro: blocking dependency",
      "reasoning": "Todas as outras features precisam de auth"
    },
    {
      "agent": "C3PO",
      "position": "Dashboard analytics: quick win, stakeholder visibility",
      "reasoning": "Mostra progresso early para stakeholders"
    }
  ],
  "criteria": "business_value, dependencies, effort, risk"
}
```

## Integration with Agent Ecosystem

### Woz (Code Architecture)

```ruby
def debate_architecture(option_a, option_b)
  response = HTTP.post("#{AGGENIE_URL}/api/v1/debate", 
    json: {
      topic: "Architecture decision",
      arguments: [option_a, option_b],
      criteria: "maintainability, performance, team_expertise"
    }
  )
  response.dig(:data, :winner)
end
```

### HAL (Strategic Planning)

```ruby
def debate_strategy(positions)
  response = HTTP.post("#{AGGENIE_URL}/api/v1/debate",
    json: {
      topic: "Strategic decision",
      arguments: positions,
      criteria: "long_term_impact, resources, risk"
    }
  )
  response.dig(:data, :winner)
end
```

## Script Wrapper

```bash
./scripts/agent_debate.sh "topic" "agent1:position:reasoning" "agent2:position:reasoning"
```

## Notes

- O Comparator faz comparação pairwise (2 participantes por vez)
- Para mais de 2 participantes, o debate pode ser extendido para tournament style
- O reasoning inclui justificativa detalhada para audit trail
