#!/bin/bash

cd /app/$USER

python manage.py sync
python manage.py set_passwords_to 123
