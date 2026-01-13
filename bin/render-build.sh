#!/usr/bin/env bash
set -e

# Install dependencies
bundle install

# Run database migrations
bundle exec rails db:migrate

# Precompile assets
bundle exec rails assets:precompile

# Exit successfully
exit 0
