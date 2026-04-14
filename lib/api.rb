# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'logger'

# Load ActiveGenie configuration
require_relative 'config/initializers/active_genie'

# API Routes
module AgGenie
  class API < Sinatra::Base
    set :port, ENV['PORT'] || 4567
    set :environment, ENV['RACK_ENV'] || :development
    set :logging, true
    set :logger, Logger.new($stdout)

    # =========================================================================
    # GET /health - Health check
    # =========================================================================
    get '/health' do
      json status: 'ok', timestamp: Time.now.iso8601
    end

    # =========================================================================
    # GET / - Root info
    # =========================================================================
    get '/' do
      json(
        service: 'AgGenie - ActiveGenie Microservice',
        version: '1.0.0',
        endpoints: %w[
          /health
          /api/v1/compare
          /api/v1/score
          /api/v1/rank
          /api/v1/extract
        ]
      )
    end

    # =========================================================================
    # POST /api/v1/compare - Compare two options using Comparator
    # =========================================================================
    post '/api/v1/compare' do
      content_type :json

      # Parse request body
      body = JSON.parse(request.body.read)
      
      player_a = body['player_a']
      player_b = body['player_b']
      criteria = body['criteria']
      provider = body['provider'] || :openai
      model = body['model']

      # Validation
      unless player_a && player_b && criteria
        halt 400, json(
          error: 'Missing required parameters',
          required: %w[player_a player_b criteria],
          received: body.keys
        )
      end

      # Build config
      config = { provider_name: provider.to_sym }
      config[:model] = model if model

      # Execute Comparator
      result = ActiveGenie::Comparator.call(player_a, player_b, criteria, config)

      # Return response
      json(
        success: true,
        data: {
          winner: result.data[:winner],
          loser: result.data[:loser],
          reasoning: result.data[:reasoning]
        },
        meta: {
          provider: provider,
          model: model || 'default'
        }
      )
    rescue ActiveGenie::Error => e
      logger.error "ActiveGenie error: #{e.message}"
      halt 500, json(error: 'ActiveGenie processing error', message: e.message)
    rescue JSON::ParserError => e
      halt 400, json(error: 'Invalid JSON', message: e.message)
    rescue StandardError => e
      logger.error "Unexpected error: #{e.message}"
      halt 500, json(error: 'Internal server error', message: e.message)
    end

    # =========================================================================
    # POST /api/v1/score - Evaluate content with AI jury
    # =========================================================================
    post '/api/v1/score' do
      content_type :json

      body = JSON.parse(request.body.read)
      
      content = body['content']
      criteria = body['criteria']
      reviewers = body['reviewers'] # Optional array
      provider = body['provider'] || :openai
      model = body['model']

      unless content && criteria
        halt 400, json(
          error: 'Missing required parameters',
          required: %w[content criteria],
          received: body.keys
        )
      end

      config = { provider_name: provider.to_sym }
      config[:model] = model if model

      result = if reviewers
        ActiveGenie::Scorer.call(content, criteria, reviewers, config)
      else
        ActiveGenie::Scorer.call(content, criteria, config)
      end

      json(
        success: true,
        data: {
          scores: result.data.reject { |k, _| k.to_s.end_with?('_reasoning') },
          reasonings: result.data.select { |k, v| k.to_s.end_with?('_reasoning') },
          final_score: result.data[:final_score]
        },
        meta: { provider: provider, model: model || 'default' }
      )
    rescue ActiveGenie::Error => e
      logger.error "ActiveGenie error: #{e.message}"
      halt 500, json(error: 'ActiveGenie processing error', message: e.message)
    rescue JSON::ParserError => e
      halt 400, json(error: 'Invalid JSON', message: e.message)
    rescue StandardError => e
      logger.error "Unexpected error: #{e.message}"
      halt 500, json(error: 'Internal server error', message: e.message)
    end

    # =========================================================================
    # POST /api/v1/rank - Rank multiple items using tournament + ELO
    # =========================================================================
    post '/api/v1/rank' do
      content_type :json

      body = JSON.parse(request.body.read)
      
      items = body['items']
      criteria = body['criteria']
      provider = body['provider'] || :openai
      model = body['model']

      unless items && criteria
        halt 400, json(
          error: 'Missing required parameters',
          required: %w[items criteria],
          received: body.keys
        )
      end

      unless items.is_a?(Array) && items.length >= 2
        halt 400, json(
          error: 'Items must be an array with at least 2 elements',
          received_items: items.class.to_s,
          items_length: items.is_a?(Array) ? items.length : 'N/A'
        )
      end

      config = { provider_name: provider.to_sym }
      config[:model] = model if model

      # Execute Ranker
      result = ActiveGenie::Ranker.call(items, criteria, config)

      # Format ranking response
      ranked_data = result.data[:rankings].map.with_index(1) do |item, index|
        {
          rank: index,
          item: item[:item],
          score: item[:score],
          elo: item[:elo]
        }
      end

      json(
        success: true,
        data: {
          rankings: ranked_data,
          winner: result.data[:winner],
          total_items: items.length
        },
        meta: {
          provider: provider,
          model: model || 'default'
        }
      )
    rescue ActiveGenie::Error => e
      logger.error "ActiveGenie error: #{e.message}"
      halt 500, json(error: 'ActiveGenie processing error', message: e.message)
    rescue JSON::ParserError => e
      halt 400, json(error: 'Invalid JSON', message: e.message)
    rescue StandardError => e
      logger.error "Unexpected error: #{e.message}"
      halt 500, json(error: 'Internal server error', message: e.message)
    end
  end
end
