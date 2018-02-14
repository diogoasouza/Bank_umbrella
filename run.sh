#!/bin/sh
set -e
# Sleep to let the db server come up
sleep 5

mix deps.get
mix deps.compile
cd apps/bank_web/web/static/assets/
npm install
cd ../../../../../
mix ecto.create
mix ecto.migrate
mix phx.server
