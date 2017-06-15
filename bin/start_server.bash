#!/bin/bash
#exit on error
set -e

BUNDLE=/usr/local/bin/ruby2.4/bundle

echo "Installing libraries"
$BUNDLE install --path vendor/bundle

echo "Running db seed"
$BUNDLE exec rake admin:db:seed

echo "Starting server"
$BUNDLE exec rake admin:server:start_inline
