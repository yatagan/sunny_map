# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
brunch build --production
MIX_ENV=prod mix phoenix.digest

# Custom tasks (like DB migrations)
MIX_ENV=prod mix ecto.migrate

# Finally run the server
PORT=4101 MIX_ENV=prod mix phoenix.server
