# AgGenie - ActiveGenie Microservice

Microservice ActiveGenie para o ecossistema de agentes OpenClaw.

## Módulos Disponíveis

| Módulo | Descrição |
|--------|-----------|
| **Comparator** | Compara duas opções e determina vencedor com debate estruturado |
| **Scorer** | Avalia conteúdo com jury de especialistas |
| **Ranker** | Ranqueia múltiplas opções usando tournament + ELO |
| **Extractor** | Extrai dados estruturados de texto não estruturado |

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

## Exemplos de Uso

### Compare

```bash
curl -X POST http://localhost:4567/api/v1/compare \
  -H "Content-Type: application/json" \
  -d '{
    "player_a": "Usar Redis para cache",
    "player_b": "Usar PostgreSQL com materialized view",
    "criteria": "Avaliar: performance, custo, manutibilidade"
  }'
```

### Score

```bash
curl -X POST http://localhost:4567/api/v1/score \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Tutorial de como instalar o sistema...",
    "criteria": "Avaliar clareza e completude"
  }'
```

## Desenvolvimento

```bash
# Executar testes
bundle exec rspec

# Verificar sintaxe
ruby -c lib/api.rb
```

## Docker

```bash
# Build
docker build -t aggenie .

# Run
docker run -p 4567:4567 -e OPENAI_API_KEY=... aggenie
```

## Arquitetura

```
lib/
├── api.rb          # Rotas principais
├── api/
│   └── ...         # Endpoints
├── models/
│   └── ...         # Modelos de dados
└── services/
    └── ...         # Lógica de negócio
```

## Roadmap

- [x] Issue #1: Setup ActiveGenie gem e config inicial
- [ ] Issue #2: Endpoint /compare (Comparator)
- [ ] Issue #3: Endpoint /score (Scorer)
- [ ] Issue #4: Endpoint /rank (Ranker)
- [ ] Issue #5: Endpoint /extract (Extractor)
- [ ] Issue #6: Docker setup
- [ ] Issue #7: Integração com Woz
- [ ] Issue #8: Workflow debate entre agentes
- [ ] Issue #9: Documentação

---

OpenClaw Ecosystem - Powered by ActiveGenie