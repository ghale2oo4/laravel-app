#!/bin/sh
# Exit immediately if a command exits with a non-zero status
set -e

# 1. Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL at $DB_HOST:$DB_PORT..."
# Using a simple loop with 'nc' (netcat) to check the port
while ! nc -z "$DB_HOST" "$DB_PORT"; do
  echo "Database is unavailable - sleeping..."
  sleep 2
done

echo "PostgreSQL is up - executing migrations"

# 2. Run migrations
# The --force flag is required to run migrations in production mode
php artisan migrate --force

# 3. Cache configuration (Optional but recommended for speed)
# php artisan config:cache
# php artisan route:cache

# 4. Hand over control to the main process (php-fpm)
exec "$@"