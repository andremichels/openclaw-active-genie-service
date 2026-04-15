# AgGenie - ActiveGenie Microservice

Microservice ActiveGenie para o ecossistema de agentes OpenClaw.

## Módulos Disponíveis

| Módulo | Descrição |
|--------|-----------|
| **Comparator** | Compara duas opções e determina vencedor com debate estruturado |
| **Scorer** | Avalia conteúdo com jury de especialistas |
| **Ranker** | Ranqueia múltiplas opções usando tournament + ELO |
| **Extractor** | Extrai dados estruturados de texto não estruturado |
| **Debate** | Workflow multi-agente com Comparator como árbitro |

## Quick Start

### Prerequisites

- Ruby 3.2+
- Bundler

### Setup

```bash
# Clone o repositório
git clone https://github.com/andremichels/openclaw-active-genie-service.git
cd openclaw-active-genie-service

# Instale as dependências
bundle install

# Configure as variáveis de ambiente
cp .env.example .env
# Edite .env com suas API keys

# Inicie o servidor
rackup
# ou
ruby -Ilib lib/api.rb
```

### Docker

```bash
# Build
docker build -t aggenie .

# Run
docker-compose up -d
```

### Configuração de API Keys

O serviço suporta múltiplos providers. Configure pelo menos um:

```bash
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GOOGLE_API_KEY="..."
```

## Endpoints

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/health` | Health check |
| GET | `/` | Informações do serviço |
| POST | `/api/v1/compare` | Comparar duas opções |
| POST | `/api/v1/score` | Avaliar conteúdo |
| POST | `/api/v1/rank` | Ranquear lista |
| POST | `/api/v1/extract` | Extrair dados |
| POST | `/api/v1/debate` | Debate multi-agente |

## Exemplos Rápidos

### Compare - Comparar duas opções

```bash
curl -X POST http://localhost:4567/api/v1/compare \
  -H "Content-Type: application/json" \
  -d '{
    "player_a": "Usar Redis para cache",
    "player_b": "Usar PostgreSQL com materialized view",
    "criteria": "performance, custo, manutibilidade"
  }'
```

### Score - Avaliar conteúdo

```bash
curl -X POST http://localhost:4567/api/v1/score \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Tutorial de como instalar o sistema...",
    "criteria": "clareza, completude, utilidade"
  }'
```

### Rank - Ranquear múltiplas opções

```bash
curl -X POST http://localhost:4567/api/v1/rank \
  -H "Content-Type: application/json" \
  -d '{
    "items": ["PostgreSQL", "MySQL", "MongoDB"],
    "criteria": "performance, popularidade, facilidade"
  }'
```

### Extract - Extrair dados estruturados

```bash
curl -X POST http://localhost:4567/api/v1/extract \
  -H "Content-Type: application/json" \
  -d '{
    "text": "João Silva, 35 anos, mora em São Paulo",
    "schema": {"name": "string", "age": "number", "city": "string"}
  }'
```

### Debate - Multi-agente

```bash
curl -X POST http://localhost:4567/api/v1/debate \
  -H "Content-Type: application/json" \
  -d '{
    "topic": "Qual cache usar?",
    "arguments": [
      {"agent": "Woz", "position": "Redis", "reasoning": "maduro"},
      {"agent": "HAL", "position": "Cloudflare", "reasoning": "global"}
    ],
    "criteria": "performance, custo, operacional"
  }'
```

## Documentação

| Documento | Descrição |
|-----------|-----------|
| [docs/API_REFERENCE.md](docs/API_REFERENCE.md) | Referência completa da API |
| [docs/openapi.yaml](docs/openapi.yaml) | Especificação OpenAPI/Swagger |
| [docs/FAQ.md](docs/FAQ.md) | FAQ e Troubleshooting |
| [WOZ_INTEGRATION.md](WOZ_INTEGRATION.md) | Guia de integração com Woz |
| [DEBATE_WORKFLOW.md](DEBATE_WORKFLOW.md) | Workflow de debate entre agentes |

## Desenvolvimento

```bash
# Executar testes
bundle exec rspec

# Verificar sintaxe
ruby -c lib/api.rb

# Verificar com RuboCop
bundle exec rubocop
```

## Arquitetura

```
lib/
├── api.rb          # Rotas principais
└── config/
    └── initializers/
        └── active_genie.rb  # Config ActiveGenie

scripts/
├── woz_compare.sh      # Wrapper Woz
└── agent_debate.sh     # Wrapper Debate

docs/
├── API_REFERENCE.md    # Referência API
├── openapi.yaml        # OpenAPI spec
└── FAQ.md              # FAQ
```

## Roadmap

- [x] Issue #1: Setup ActiveGenie gem e config inicial
- [x] Issue #2: Endpoint /compare (Comparator)
- [x] Issue #3: Endpoint /score (Scorer)
- [x] Issue #4: Endpoint /rank (Ranker)
- [x] Issue #5: Endpoint /extract (Extractor)
- [x] Issue #6: Docker setup
- [x] Issue #7: Integração com Woz
- [x] Issue #8: Workflow debate entre agentes
- [x] Issue #9: Documentação

## Integração com Agentes

Consulte [WOZ_INTEGRATION.md](WOZ_INTEGRATION.md) para detalhes sobre como usar o serviço com o agente Woz.

Consulte [DEBATE_WORKFLOW.md](DEBATE_WORKFLOW.md) para o workflow de debate multi-agente.

---

OpenClaw Ecosystem - Powered by ActiveGenie
