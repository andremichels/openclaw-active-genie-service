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

    # Health check endpoint
    get '/health' do
      json status: 'ok', timestamp: Time.now.iso8601
    end

    # Root endpoint
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
  end
end