#!/usr/bin/env bash
set -e

# Install dependencies
bundle install

# Run database migrations
bundle exec rails db:migrate

# Run database seeds (only if no users exist)
if ! bundle exec rails runner "User.exists?" 2>/dev/null; then
  echo "Running database seeds..."
  bundle exec rails db:seed
fi

# Exit successfully
exit 0
