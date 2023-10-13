#!/bin/bash
if [ "$1" = "create_and_migrate_with_seed" ]; then
  cd /app
  rake db:create db:migrate db:seed
fi
if [ "$1" = "migrate_with_seed" ]; then
  cd /app
  rake db:migrate db:seed
fi
if [ "$1" = "seed" ]; then
  cd /app
  rake db:seed
fi
if [ "$1" = "ns" ]; then
  cd /app
  rails runner runners/dns.rb
fi
if [ "$1" = "server" ]; then
  cd /app
  rails server
fi
