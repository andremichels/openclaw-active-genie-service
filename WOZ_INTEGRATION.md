# Woz Integration Guide

This document describes how Woz (coding agent) can use the ActiveGenie service for code review tasks.

## Overview

The ActiveGenie service exposes AI-powered tools that Woz can use during code review:
- **Comparator**: Compare two code implementations or solutions
- **Scorer**: Evaluate code quality with AI jury
- **Ranker**: Rank multiple options (tournament + ELO)
- **Extractor**: Extract structured data from unstructured text

## Base URL

```
http://localhost:4567
```

For containerized deployment:
```
http://activegenie:4567
```

## Authentication

Set API keys in environment variables:
```bash
export OPENAI_API_KEY="your-key"
export ANTHROPIC_API_KEY="your-key"
```

## Use Cases

### 1. Compare Two PR Implementations

When reviewing a PR that proposes an alternative implementation:

```bash
curl -X POST http://localhost:4567/api/v1/compare \
  -H 'Content-Type: application/json' \
  -d '{
    "player_a": "Implementation A: [current code]",
    "player_b": "Implementation B: [proposed code]",
    "criteria": "readability, performance, maintainability",
    "provider": "openai"
  }'
```

### 2. Decide Between Alternative Solutions

When Woz needs to evaluate different approaches:

```bash
curl -X POST http://localhost:4567/api/v1/compare \
  -H 'Content-Type: application/json' \
  -d '{
    "player_a": "Solution 1: Use Redis for caching",
    "player_b": "Solution 2: Use in-memory cache",
    "criteria": "scalability, complexity, operational overhead",
    "provider": "openai"
  }'
```

### 3. Evaluate Code Quality

When scoring code quality:

```bash
curl -X POST http://localhost:4567/api/v1/score \
  -H 'Content-Type: application/json' \
  -d '{
    "content": "[code to evaluate]",
    "criteria": " SOLID principles, error handling, testability",
    "provider": "openai"
  }'
```

## Woz Workflow Example

```ruby
# Example: Woz uses Comparator during code review
def review_pr(pr_content, alternative_solution)
  comparison = ActiveGenie::Comparator.call(
    pr_content,
    alternative_solution,
    "code quality, performance, maintainability",
    { provider_name: :openai }
  )
  
  if comparison.data[:winner] == pr_content
    "PR implementation is better"
  else
    "Consider alternative approach"
  end
end
```

## Error Handling

The service returns standard HTTP status codes:
- `200`: Success
- `400`: Missing required parameters
- `500`: ActiveGenie processing error

## Health Check

```bash
curl http://localhost:4567/health
```

## Rate Limits

- OpenAI: 500 requests/month (free tier)
- Consider caching responses for repeated comparisons
