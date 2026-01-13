#!/usr/bin/env bash
set -e

# Install dependencies
bundle install

# Run database migrations
bundle exec rails db:migrate

# Precompile assets for production
bundle exec rails assets:precompile

# Run database seeds
echo "Running database seeds..."
bundle exec rails db:seed

# Exit successfully
exit 0
