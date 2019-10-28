#!/bin/sh

set -e

sleep 5
./manage.py migrate
./manage.py createsuperuser --username $APP_ADMIN --email $APP_EMAIL --noinput

exec "$@"
