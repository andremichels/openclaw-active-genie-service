# FAQ & Troubleshooting

Perguntas frequentes e soluções para problemas comuns.

## FAQ

### Como o Comparator decide o vencedor?

O Comparator usa um debate estruturado internamente:
1. Analisa cada opção individualmente
2. Compara contra os critérios fornecidos
3. Gera reasoning para cada posição
4. Determina vencedor baseado na análise

### Quais providers são suportados?

- **OpenAI** (default): GPT-4, GPT-3.5
- **Anthropic**: Claude 3, Claude 2
- **Google**: Gemini Pro

### Como escolher o provider?

```bash
# OpenAI (default)
"provider": "openai"

# Anthropic
"provider": "anthropic"

# Google
"provider": "google"
```

### Posso especificar o modelo?

Sim, use o campo `model`:

```json
{
  "provider": "openai",
  "model": "gpt-4-turbo-preview"
}
```

### Como funciona o ranking com ELO?

O Ranker usa sistema de tournament:
1. Cada item começa com ELO 1500
2. Comparações pairwise determinam winner/loser
3. ELO é ajustado baseado no resultado
4. Processo se repete até convergência

### Quantos itens posso ranquear?

Recomendado: 2-20 itens. Para listas maiores, considere groupings.

### Como o debate multi-agente funciona?

1. Cada agente envia sua posição
2. Comparator faz comparação pairwise
3. Gera reasoning detalhado para a decisão

---

## Troubleshooting

### "Connection refused" ao chamar localhost:4567

**Problema:** Serviço não está rodando.

**Solução:**
```bash
# Iniciar o serviço
rackup

# Ou com Docker
docker-compose up -d
```

### "ActiveGenie processing error"

**Problema:** Erro no processamento do ActiveGenie.

**Soluções:**
1. Verificar se API key está configurada:
   ```bash
   export OPENAI_API_KEY="sk-..."
   ```

2. Verificar se o modelo existe:
   ```bash
   # Tentar com modelo padrão
   "model": null
   ```

3. Ver logs para mais detalhes:
   ```bash
   rackup --verbose
   ```

### "Missing required parameters"

**Problema:** Parâmetros obrigatórios não enviados.

**Solução:** Verificar request body:
```json
{
  "player_a": "valor",  // ✅
  "player_b": "valor",  // ✅
  "criteria": "valor"   // ✅
}
```

### Response lenta ou timeout

**Problema:** AI provider está lento.

**Soluções:**
1. Verificar status do provider:
   - [OpenAI Status](https://status.openai.com)
   - [Anthropic Status](https://status.anthropic.com)

2. Usar modelo mais rápido:
   ```json
   "model": "gpt-3.5-turbo"  // Mais rápido que gpt-4
   ```

3. Implementar retry logic

### Docker: "Module not found"

**Problema:** Ruby modules não encontrados.

**Solução:**
```bash
# Rebuild da imagem
docker build --no-cache -t aggenie .

# Ou reinstall gems
bundle install
```

### Erro 500 com "undefined method"

**Problema:** ActiveGenie gem não está configurada corretamente.

**Solução:**
```bash
# Verificar gemfile
cat Gemfile

# Install dependências
bundle install

# Verificar configuração
cat config/initializers/active_genie.rb
```

---

## Debug Tips

### Verificar se serviço está rodando

```bash
curl http://localhost:4567/health
```

### Ver todos os endpoints

```bash
curl http://localhost:4567/
```

### Testar com JSON válido

```bash
curl -X POST http://localhost:4567/api/v1/compare \
  -H 'Content-Type: application/json' \
  -d '{"player_a":"a","player_b":"b","criteria":"x"}'
```

### Logs detalhados

```bash
# Development mode com logs
RACK_ENV=development ruby -Ilib lib/api.rb

# Docker com logs
docker-compose logs -f
```

---

## Contato para Suporte

- GitHub Issues: [openclaw-active-genie-service/issues](https://github.com/andremichels/openclaw-active-genie-service/issues)
- Documentação: [docs/](docs/)
