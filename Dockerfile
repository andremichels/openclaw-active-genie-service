# ------------------------------------------------------------------------------
# Stage 1: Base - Install Ruby dependencies
# ------------------------------------------------------------------------------
FROM ruby:3.2-slim AS base

# Install common dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# ------------------------------------------------------------------------------
# Stage 2: Builder - Install gems
# ------------------------------------------------------------------------------
FROM base AS builder

# Copy Gemfile and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local path 'vendor/bundle' && \
    bundle install --jobs 4 --retry 3

# ------------------------------------------------------------------------------
# Stage 3: Production - Final image
# ------------------------------------------------------------------------------
FROM base AS production

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy from builder
COPY --from=builder /app/vendor /app/vendor
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Copy application
COPY --from=base /app /app

# Set environment
ENV RACK_ENV=production \
    PORT=4567 \
    BUNDLE_PATH="vendor/bundle"

# Expose port
EXPOSE 4567

# Start command
CMD ["bundle", "exec", "rackup", "config.ru", "-p", "4567", "-o", "0.0.0.0"]