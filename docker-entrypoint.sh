#!/bin/bash
set -e

# Wait for Redis to be ready
echo "Waiting for Redis to be ready..."
until python -c "
import redis
import os
host, port = os.environ.get('REDIS_ENDPOINT_URL', 'redis-db:6379').split(':')
r = redis.Redis(host=host, port=port)
r.ping()
"; do
  echo "Redis is unavailable - sleeping"
  sleep 1
done

echo "Redis is ready!"

# Initialize Redis with demo data
python -c "
from chat.utils import init_redis
init_redis()
"

echo "Redis initialization completed"

# Start gunicorn
echo "Starting gunicorn..."
exec gunicorn --bind :$PORT \
    --worker-class eventlet \
    --workers 1 \
    --log-level debug \
    --access-logfile - \
    --error-logfile - \
    app:app