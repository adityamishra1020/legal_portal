#!/usr/bin/env bash
set -e

# Install dependencies
bundle install

# Run database migrations
bundle exec rails db:migrate

# Run database seeds (always run to create/update default users)
echo "Running database seeds..."
bundle exec rails db:seed

# Exit successfully
exit 0
