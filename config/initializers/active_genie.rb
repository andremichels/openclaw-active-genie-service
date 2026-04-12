# frozen_string_literal: true

# ActiveGenie Configuration
# Configure seus providers via variáveis de ambiente
#
# Variáveis necessárias:
# - OPENAI_API_KEY
# - ANTHROPIC_API_KEY
# - GOOGLE_API_KEY

require 'active_genie'

ActiveGenie.configure do |config|
  # OpenAI Configuration
  if ENV['OPENAI_API_KEY']
    config.providers.openai.api_key = ENV['OPENAI_API_KEY']
  end

  # Anthropic Configuration
  if ENV['ANTHROPIC_API_KEY']
    config.providers.anthropic.api_key = ENV['ANTHROPIC_API_KEY']
  end

  # Google Configuration
  if ENV['GOOGLE_API_KEY']
    config.providers.google.api_key = ENV['GOOGLE_API_KEY']
  end

  # Default provider (optional)
  # config.default_provider = :openai
end

puts "[ActiveGenie] Configured with providers: #{ActiveGenie.configuration.providers.keys.select { |k| ActiveGenie.configuration.providers[k].api_key }.join(', ')}"