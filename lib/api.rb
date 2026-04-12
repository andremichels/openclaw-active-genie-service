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
  end
end